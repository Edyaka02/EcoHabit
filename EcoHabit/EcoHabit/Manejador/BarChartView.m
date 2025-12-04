//
//  BarChartView.m
//  EcoHabit
//
//  Created by Guest User on 03/12/25.
//

#import "BarChartView.h"

@implementation BarChartView

- (void)drawRect:(CGRect)rect {
    if (!self.datos || self.datos.count == 0) return;

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat ancho = rect.size.width;
    CGFloat alto = rect.size.height;

    // Ordenar claves por valor descendente
    NSArray *clavesOrdenadas = [self.datos keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj2 compare:obj1];
    }];

    // Limitar a 5 si es por categoría
    NSArray *claves = self.titulo && [self.titulo containsString:@"Categoría"]
        ? [clavesOrdenadas subarrayWithRange:NSMakeRange(0, MIN(5, clavesOrdenadas.count))]
        : clavesOrdenadas;

    CGFloat maxValor = 0;
    for (NSString *k in claves) {
        double v = [self.datos[k] doubleValue];
        if (v > maxValor) maxValor = v;
    }

    CGFloat margen = 10.0;
    CGFloat espacio = 5.0;
    CGFloat anchoBarra = (ancho - 2 * margen - (claves.count - 1) * espacio) / claves.count;

    UIFont *fuente = [UIFont systemFontOfSize:10];
    NSDictionary *atributosTexto = @{NSFontAttributeName: fuente, NSForegroundColorAttributeName: UIColor.blackColor};

    for (int i = 0; i < claves.count; i++) {
        NSString *clave = claves[i];
        double valor = [self.datos[clave] doubleValue];

        CGFloat x = margen + i * (anchoBarra + espacio);
        CGFloat alturaBarra = (valor / maxValor) * (alto - 40);
        CGFloat y = alto - alturaBarra - 20;

        CGRect barra = CGRectMake(x, y, anchoBarra, alturaBarra);
        [[UIColor systemGreenColor] setFill];
        CGContextFillRect(ctx, barra);

        // Etiqueta de valor encima
        NSString *valorStr = [NSString stringWithFormat:@"%.0f", valor];
        CGSize valorSize = [valorStr sizeWithAttributes:atributosTexto];
        CGRect valorRect = CGRectMake(x + (anchoBarra - valorSize.width) / 2, y - valorSize.height - 2, valorSize.width, valorSize.height);
        [valorStr drawInRect:valorRect withAttributes:atributosTexto];

        // Etiqueta de eje X
        NSString *etiqueta = clave.length > 4 ? [clave substringFromIndex:clave.length - 2] : clave;
        CGSize size = [etiqueta sizeWithAttributes:atributosTexto];
        CGRect textoRect = CGRectMake(x + (anchoBarra - size.width) / 2, alto - 18, size.width, size.height);
        [etiqueta drawInRect:textoRect withAttributes:atributosTexto];
    }
}

@end
