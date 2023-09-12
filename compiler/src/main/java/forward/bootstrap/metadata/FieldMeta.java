// SPDX-License-Identifier: MIT

package forward.bootstrap.metadata;

import forward.ForwardParser.FieldDefinitionContext;
import forward.bootstrap.ScopeManager;

public record FieldMeta(String name, boolean isStatic, TypeMeta type) {
    public static FieldMeta fromContext(ScopeManager scopeManager, FieldDefinitionContext ctx) {
        var name = ctx.IDENTIFIER().getText();
        var isStatic = ctx.getText().startsWith("static");
        var type = TypeMeta.fromContext(scopeManager, ctx.type());
        return new FieldMeta(name, isStatic, type);
    }

    public String asDescriptor() {
        return type.asDescriptor();
    }
}
