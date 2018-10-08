# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo; y,
2. Sombrear su superficie a partir de los colores de sus vértices.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Opcionales:

1. Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas; y,
2. Sombrear su superficie mediante su [mapa de profundidad](https://en.wikipedia.org/wiki/Depth_map).

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [frames](https://github.com/VisualComputing/frames/releases).

## Integrantes

Dos, o máximo tres si van a realizar al menos un opcional.

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|Juan David Rojas            |  juandavidro           |
|Wilson Eduardo Tellez            |  wilson911013           |

## Discusión

Describa los resultados obtenidos. 
En el caso de anti-aliasing describir las técnicas exploradas, citando las referencias.

* La rasterización se realizo usando la norma del vector. 
* Antialiasing: https://en.wikipedia.org/wiki/Multisample_anti-aliasing .
El anti-aliasing de multisample, si cualquiera de las ubicaciones de múltiples muestras en un píxel está cubierta por el 
triángulo que se está representando, se debe realizar un cálculo de sombreado para ese triángulo. Sin embargo, este cálculo 
solo debe realizarse una vez para todo el píxel, independientemente de la cantidad de posiciones de muestra cubiertas; 
el resultado del cálculo de sombreado se aplica simplemente a todas las ubicaciones de muestras múltiples relevantes. 
En total se usaron 4 subpixeles por cada pixel para el ejemplo. 
* https://elcodigografico.wordpress.com/2014/03/29/coordenadas-baricentricas-en-triangulos/ .
Las coordenadas baricéntricas nos ayudan para a cada píxel obtener sus coordenadas baricéntricas las cuales pueden 
ser empleadas para interpolar valores de los vértices del triángulo como color, vector normal, valor de profundidad, 
coordenadas de textura, valores de peso en la edición de formas, entre otros.


