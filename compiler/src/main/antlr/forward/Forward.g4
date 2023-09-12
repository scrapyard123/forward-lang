// SPDX-License-Identifier: MIT

grammar Forward;

@header {
    package forward;
}

program: importSection? classDefinition (fieldDefinition | methodDefinition)*;

importSection: 'import' '{' IDENTIFIER+ '}';

classDefinition: 'class' IDENTIFIER (':' baseClass)?;
baseClass: IDENTIFIER;

fieldDefinition: 'static'? IDENTIFIER ':' type;

methodDefinition: 'static'? IDENTIFIER '(' parameter* ')' ':' type '{' statement* '}';
parameter: IDENTIFIER ':' type;

statement:
    variableDefinition | assignmentStatement | expressionStatement |
    conditionalStatement | loopStatement |
    returnStatement;

variableDefinition: 'var' (IDENTIFIER ':' type)+;
assignmentStatement: IDENTIFIER '=' expression;
expressionStatement: expression;

conditionalStatement: 'if' expression '{' statement* '}' elseBranch?;
elseBranch: 'else' '{' statement* '}';
loopStatement: 'while' expression '{' statement* '}';

returnStatement: 'return' expression?;

expression: term (operator term)*;
term: unaryOp* (LITERAL ('L' | 'F')? | accessExpression | '(' expression ')');

accessExpression: accessTerm ('->' accessTerm)*;
accessTerm: IDENTIFIER ('(' expression* ')')?;

// TODO: Add support for !, &&, ||
unaryOp: '-';
operator:
    '*' | '/' | '%' |
    '+' | '-' |
    '<<' | '>>' | '>>>' |
    '<' | '>' | '<=' | '>=' |
    '==' | '!=' |
    '&' |
    '^' |
    '|';

type: 'void' | 'int' | 'long' | 'float' | 'double' | IDENTIFIER;

LITERAL: [0-9.]+;
IDENTIFIER: [a-zA-Z] ([a-zA-Z0-9.$])*;

LINE_COMMENT: '//' ~[\r\n]* -> skip;
WS: [ \r\n\t]+ -> channel(HIDDEN);