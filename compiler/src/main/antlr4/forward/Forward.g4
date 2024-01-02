// SPDX-License-Identifier: MIT

grammar Forward;

program: importSection? classDefinition (fieldDefinition | methodDefinition)*;

importSection: 'import' '{' IDENTIFIER+ '}';

classDefinition:
    ('interface' | 'class') IDENTIFIER ('<:' baseClass)?
    (':' (interfaceClass)+)?
    annotationBlock?;
baseClass: IDENTIFIER;
interfaceClass: IDENTIFIER;

fieldDefinition: 'static'? IDENTIFIER ':' type annotationBlock?;

codeBlock: '{' statement* '}';

methodDefinition:
    'static'? IDENTIFIER '(' parameter* ')' ':' type
    annotationBlock?
    codeBlock?;
parameter: IDENTIFIER ':' type annotationBlock?;

annotationBlock: '[' annotationDefinition+ ']';
annotationDefinition: type ('[' annotationParameter+ ']')?;
annotationParameter: IDENTIFIER '=' LITERAL;

statement:
    variableDefinitionStatement | assignmentStatement | expressionStatement |
    conditionalStatement | loopStatement | breakContinueStatement |
    returnStatement;

variableDefinitionStatement: 'var' (IDENTIFIER ':' type ('=' expression)?)+;
assignmentStatement: IDENTIFIER '=' expression;
expressionStatement: expression;

conditionalStatement: 'if' expression codeBlock elseBranch?;
elseBranch: 'else' codeBlock;

loopStatement: 'while' expression codeBlock thenBlock?;
thenBlock: 'then' codeBlock;
breakContinueStatement: 'break' | 'continue';

returnStatement: 'return' expression?;

expression: term (operator term)*;
term: unaryOp* (LITERAL | accessExpression | '(' expression ')');

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

type: ('void' | 'int' | 'long' | 'float' | 'double' | IDENTIFIER) '[]'?;

LITERAL: [0-9.]+ ('L' | 'F')? | '"' .*? '"';
IDENTIFIER: [a-zA-Z] ([a-zA-Z0-9_.$])*;

LINE_COMMENT: '//' ~[\r\n]* -> skip;
WS: [ \r\n\t]+ -> channel(HIDDEN);
