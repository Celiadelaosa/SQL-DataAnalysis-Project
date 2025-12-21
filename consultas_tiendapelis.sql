--RESOLUCIÓN DE LAS CONSULTAS PROYECTO SQL

--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ.
select "title" as "películas_con_clasificación_R"
from "film"
where "rating"='R';

--*********************************************************************************************

--3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
select concat("first_name",' ', "last_name") as Nombre_actor   --Usamos concat para crear una columna con el nombre completo del actor en lugar de tener el nombre y apellido separados
from "actor"
where "actor_id" between 30 and 40;

--********************************************************************************************

--4. Obtén las películas cuyo idioma coincide con el idioma original.
select "title" as Películas_en_idioma_original
from "film"
where "language_id"="original_language_id";

/*al obtener una lista vacía, he querido comprobar si la consulta era 
 correcta "a mano" , es decir, visualizando 
 las columnas del identificador del idioma y del idioma original para
 ver si encontraba alguna coincidencia
lo he hecho con esta consulta
*/

select "film"."title","film"."language_id","film"."original_language_id"
from "film";

/*al ejecutarla he visto que los valores de la columna original_language_id son todos NULL, 
 lo que puede representar un 
 error en la recogida de datos
 */

--***************************************************************************************************

--5. Ordena las películas por duración de forma ascendente.
select "film"."title", "film"."length" as duración_en_min
from "film"
order by "length" ASC;

--***************************************************************************************************

--6.  Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
select concat("first_name",' ', "last_name") as Actores_con_apellido_Allen
from "actor"
where "last_name"='ALLEN';

--**************************************************************************************************

--7.  Encuentra la cantidad total de películas en cada clasificación de la tabla 
--    “filmˮ y muestra la clasificación junto con el recuento.

select "rating" , COUNT("rating") as total_películas
from "film"
group by "rating"; --usamos un group by para filtrar las películas por rating

--**************************************************************

--8. Encuentra el título de todas las películas que son ‘PG13ʼ o tienen una 
   --duración mayor a 3 horas en la tabla film.

--comienzo estudiando las unidades de la columna length
select "length"
from "film";

--se observa que las unidades de tiempo son los minutos, así que la condición para el tiempo será mayor a 180
--esta query es la solución
select "title"
from "film"
where "rating"='PG-13' or "length">180;


--la siguiente consulta me permite ver el "rating" y duración para ver si la consulta anterior es correcta
select "title", "rating", "length"
from "film"
where "rating"='PG-13' or "length">180;

--**************************************************************

--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select ROUND(VARIANCE("replacement_cost"), 3) as variabilidad_reemplazo_peliculas --calculamos la variabilidad con 3 decimales
from "film";

--**************************************************************

--10.  Encuentra la mayor y menor duración de una película de nuestra BBDD.
select MIN("length") as "Duracion_minima_minutos", MAX("length") as "Duracion_maxima_minutos"
from "film";

--**************************************************************

--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select "rental"."rental_date", "payment"."amount" as coste_antepenultimo_alquiler --seleccionamos las fechas de alquiler y los costes
from "rental"
left join "payment"
on "rental"."rental_id"="payment"."rental_id"
order by "rental"."rental_date" desc   --ordenamos las fechas de más recientes a más antiguas
limit 1 offset 2; --selelccionamos una sola fila omitiendo las dos primeras (último y penúltimo pago)

--**************************************************************

--12. Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
select "title"
from "film"
where "rating" not in ('G', 'NC-17'); --usamos un not in para no tener en cuenta las filas donde la columna "rating" tenga esos valores

--**************************************************************

--13. 
/* Encuentra el promedio de duración de las películas para cada 
clasificación de la tabla film y muestra la clasificación junto con el 
promedio de duración. */
select "rating", round(avg("length"),2) as Duracion_media_en_min  --redondeamos la duración a 2 decimales
from "film"
group by "rating";

--**************************************************************

--14.  Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select "title", "length" as Duracion --añado la duración de la película y la ordeno de forma ascendente para verificar que es correcto
from "film"
where "length"> 180
order by "length" asc;

--**************************************************************

--15. ¿Cuánto dinero ha generado en total la empresa?
select SUM("amount") as "total_empresa"
from "payment";

--**************************************************************

--16. Muestra los 10 clientes con mayor valor de id.
select "customer_id", concat ("first_name",' ', "last_name") as nombre_cliente --queremos el nombre completo del cliente
from "customer"
order by "customer_id" desc --ordeno en sentido descendente para poder seleccionar los 10 primeros
limit 10; --selecciono solo los 10 primeros

--**************************************************************

-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
select  concat("actor"."first_name", ' ', "actor"."last_name") as actores_de_Egg_Igby --usamos concat para tener el nombre completo
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
left join "film"
on "film_actor"."film_id"="film"."film_id"
where "film"."title"='EGG IGBY';   --queremos que sean acotres de esa película concreta

--**************************************************************

--18. Selecciona todos los nombres de las películas únicos.

select DISTINCT "title"
from "film"
order by "title" asc; --lo ordenamos por orden alfabético para que sea más sencillo

--**************************************************************

--19.  Encuentra el título de las películas que son comedias y tienen una 
--duración mayor a 180 minutos en la tabla “filmˮ.
select "title" as Comedias_de_más_de_180_min --seleccionamos el título
from "film"
left join "film_category"
on "film"."film_id"="film_category"."film_id"
left join "category"
on "film_category"."category_id"="category"."category_id"
where "category"."name"='Comedy' and "film"."length">180; --de películas de comedia que duren más de 180 min

--**************************************************************

--20. 
/* Encuentra las categorías de películas que tienen un promedio de 
duración superior a 110 minutos y muestra el nombre de la categoría 
junto con el promedio de duración.
*/
select "category"."name", round(AVG("film"."length"), 2) as duración_promedio --queremos mostrar el nombre de la categoría y la duración promedio con 2 decimales
from "film"
left join "film_category"
on "film"."film_id"="film_category"."film_id"
left join "category"
on "film_category"."category_id"="category"."category_id"
group by "category"."name" --lo agrupamos por categoría
having round(AVG("film"."length"), 2)>110
order by "category"."name" asc; --ordenamos la categoría por orden alfabético para simplificar
--**************************************************************

--21.  ¿Cuál es la media de duración del alquiler de las películas?

select AVG("rental_duration") as duracion_media_alquiler --en este caso concreto usar la función round sería útil ya que el valor que se obtiene es prácticamente 5
from "film";

--**************************************************************

--22.Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat("first_name",' ', "last_name") as nombre_completo_actor --usamos concat para obtener el nombre completo de todos los actores y actrices
from "actor"
order by "first_name" asc; --además los ordenamos por orden alfabético para mayor comodidad (aunque no lo pida el ej)

--**************************************************************

--23.Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select "rental_date", count("rental_id") --contamos la cantidad de alquileres
from "rental"
group by "rental_date"
order by count("rental_id") desc;

--**************************************************************

--24. Encuentra las películas con una duración superior al promedio.
select "title", "length"
from "film"
where "length"> (                    --como podemos usar la función AVG (ni ninguna de agregación) dentro del where, abrimos una subconsulta
          select (AVG("length"))     --podría escribirse seguido, pero, como buena práctica, separamos en líneas aparte
          from "film"
)
order by "length" asc; --la ordeno por duración ascendente para verificar que todas las duraciones son superiores a la media 

--**************************************************************

--25. Averigua el número de alquileres registrados por mes.

select 
extract(year from "rental_date") as año,    --exgtraemos el mes de la fecha
extract(month from "rental_date") as mes,   --extraemos el año de la fecha (si se han realizado alquileres en el mes 5 del año 2005 y 2006 p.ej, no queremos mezclarlos)
COUNT("rental_id") as numero_alquileres     --contamos el número de alquileres realizados
from "rental" 
group by año, mes                --agrupamos por mes y año
order by año,mes;                --ordenamos para mayor claridad
 


--**************************************************************

--26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select ROUND(AVG("amount"), 3) as promedio_pago, ROUND(VARIANCE("amount"), 3) as varianza_pago, ROUND(STDDEV("amount"), 3) as desviacion_estandar_pago
from "payment";

--lo calculamos con 3 decimales y ponemos nombre a las columnas para mayor claridad

--**************************************************************

--27.  ¿Qué películas se alquilan por encima del precio medio?
select "title" as peliculas_precio_elevado
from "film"
where  "rental_rate"> (
           select AVG("rental_rate") 
           from "film"); --hacemos una subconsulta ya que no podemos usar la funicón de agregación dentro de un where directamente

--**************************************************************

--28. Muestra el id de los actores que hayan participado en más de 40 películas.
SELECT "actor_id" as actor_id_mas_de_40_peliculas
FROM "film_actor" 
GROUP BY "actor_id"
HAVING COUNT("film_id") > 40;

--**************************************************************

--29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.

--entiendo la condición de que estén disponibles como que el numero de peliculas que hay sea distinto de 0
--no simplemente como que no estén

select "film"."title" , COUNT("inventory"."film_id") as numero_de_peliculas_disponbible --muestra el titulo de la pelicula con el numero de pelis disponibles en el inventario (si no hay ninguna devuelve 0)
from "film"
left join "inventory"
on "film"."film_id"="inventory"."film_id"
group by "film"."title" 
order by "film"."title" asc; --ordenamos los titulos por orden alfabetico para facilitar la posible consulta para el cliente

--**************************************************************

--30. Obtener los actores y el número de películas en las que ha actuado.
select CONCAT("actor"."first_name",' ', "actor"."last_name") as nombre_actor, COUNT("film_actor"."film_id") as numero_peliculas
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
group by CONCAT("actor"."first_name",' ', "actor"."last_name")
order by  "nombre_actor" asc; --lo ordenamos por orden alfabetico

--**************************************************************

--31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas
-- películas no tienen actores asociados.

--inicialmente he escrito este código, pero al ejecutarlo me devolvía en una columna las películas y en otra los actores 
--y como hay varios actores para la misma película, el título de la misma aparece en varias filas
select "film"."title", CONCAT("actor"."first_name",' ', "actor"."last_name") as actores
from "film"
left join "film_actor"
on "film"."film_id"="film_actor"."film_id"
left join "actor"
on "film_actor"."actor_id"="actor"."actor_id"
group by "film"."title", CONCAT("actor"."first_name",' ', "actor"."last_name")
order by "film"."title" asc;

--he buscado una función que me permitiese poner en una sola fila la película y todos los actores correspondientes y he encontrado que con la función STRING_AGG
--podía hacerlo. Así, solo hemos de buscar la película en la columna izquierda y ver la 
--lista de actores que participan en la derecha
--como STRING_AGG es una 'agregate function' me devolverá NULL si no hay ningún actor

select "film"."title", STRING_AGG ("actor"."first_name" || ' ' || "actor"."last_name", ', ') as actores
from "film"
left join "film_actor"
on "film"."film_id"="film_actor"."film_id"
left join "actor"
on "film_actor"."actor_id"="actor"."actor_id"
group by "film"."title"
order by "film"."title" asc;

--**************************************************************

--32. Obtener todos los actores y mostrar las películas en las que han 
--actuado, incluso si algunos actores no han actuado en ninguna película.

--el código será similar al caso anterior, como he descubierto la función STRING_AGG la uso directamente
select CONCAT("actor"."first_name",' ', "actor"."last_name") as actores, STRING_AGG ("film"."title", ' , ') as películas
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
left join "film"
on "film_actor"."film_id"="film"."film_id"
group by CONCAT("actor"."first_name",' ', "actor"."last_name") --no uso el alias porque, debido al orden de ejecución, para esta función "no existe" la columna actores 
order by actores asc; --ordenamos por orden alfabético para mayor claridad

--**************************************************************

--33. Obtener todas las películas que tenemos y todos los registros de alquiler.
select "film"."title", "rental"."rental_date", "rental"."return_date"
from "film"
left join "inventory"
on "film"."film_id"="inventory"."film_id"
left join "rental"
on "inventory"."inventory_id"="rental"."inventory_id";
 
--he interpretado el registro de alquiler como la fecha en la que se alquilaron y devolvieron las películas

--**************************************************************

--34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select CONCAT ("customer"."first_name", ' ', "customer"."last_name") as cliente, SUM("payment"."amount") as gasto_total
from "customer"
left join "payment"
on "customer"."customer_id"="payment"."customer_id"
group by CONCAT ("customer"."first_name", ' ', "customer"."last_name")
order by gasto_total desc --ordenamos el gasto total de forma descendente para poder tener a los de mayor gasto al principio de la lista
limit 5; --seleccionamos a los 5 primeros usando limit

--**************************************************************

--35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select CONCAT("first_name",' ', "last_name") as actores_llamados_Johnny
from "actor"
where "first_name"='JOHNNY';

--**************************************************************

--36. Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
 
select "first_name" as Nombre, "last_name" as Apellido
from "customer"


--**************************************************************

--37. Encuentra el ID del actor más bajo y más alto en la tabla actor.

select MIN("actor_id") as id_actor_mas_bajo, MAX("actor_id") as id_actor_mas_alto
from "actor";

--**************************************************************

 --38. Cuenta cuántos actores hay en la tabla “actorˮ.

select COUNT("actor_id") as número_actores
from "actor";
 
 --**************************************************************
 
 --39.  Selecciona todos los actores y ordénalos por apellido en orden ascendente.

select CONCAT("first_name",' ', "last_name") as actores_en_orden_de_apellido_ascendente
from "actor"
order by "last_name" asc;

--**************************************************************

 --40. Selecciona las primeras 5 películas de la tabla “filmˮ.
select "title"
from "film"
limit 5;
 
 --**************************************************************
 --41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

--con esta query contamos cuántas veces se repite cada nombre

select "first_name" as nombres, COUNT("first_name") as numero_actores_con_ese_nombre
from "actor"
group by "first_name";

--con esta query vemos el (los) nombres más repetidos

select "first_name" as nombres_mas_comunes, COUNT("first_name") as numero_actores_con_nombres_más_repetidos
from "actor"
group by "first_name"
having COUNT("first_name")= (  --hacemos una subconsulta para comparar cada recuento de nombres con el maximo de los mismos.Lo hacemos porque no podemos hacer COUNT(MAX) ni tampoco usar una función de agregación dentro de un where
       select MAX(conteo)      --es mejor leer el codigo de "dentro hacia fuera" es decir, contamos el numero de nombres para cada nombre (por ello usamos el group by) y luego hacemos el maximo 
       from (select COUNT("first_name") as conteo
             from "actor"
             group by "first_name") as sub
);
       
--**************************************************************

 --42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select "rental"."rental_id", CONCAT("customer"."first_name", ' ', "customer"."last_name") as nombre_cliente --para encontrar todos los alquileres podemos considerar el rental_id que es único
from "rental"
left join "customer"
on "rental"."customer_id"="customer"."customer_id";

--**************************************************************

--43.Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.

--lo he hecho mostrando el título de las películas alquiladas, pero también podríamos querer mostrar el id del alquiler

select CONCAT("customer"."first_name", ' ', "customer"."last_name") as nombre_cliente, STRING_AGG ("film"."title", ' , ') as películas_alquiladas
from "customer"
left join "rental"
on "customer"."customer_id"="rental"."customer_id"
left join "inventory"
on "rental"."inventory_id"="inventory"."inventory_id"
left join "film"
on "inventory"."film_id"="film"."film_id"
group by CONCAT("customer"."first_name", ' ', "customer"."last_name");

--como todas las columnas tenían un valor, es decir, en principio no había ningún cliente sin alquiler, he comprobado que
--todos los clientes tenían algún identificador de alquiler ascociado con esta query
select "rental"."customer_id", "rental"."rental_id"
from "rental"
where "rental_id" is NULL;
--no me ha devuelto ningún valor

--**************************************************************

--44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select "film".*, "category".*
from "film"
cross join "category";

--La consulta hace el producto cartesiano de las dos tablas. No aporta ningún valor ya que solo da las posibles categorías 
--a las que podría pertenecer cada película,es decir, nos proporciona los datos de cada película y nos
-- da esos mismos datos para cada categoría


--**************************************************************

--45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select CONCAT ("actor"."first_name", ' ', "actor"."last_name") as actores_de_accion
from "actor"
left join "film_actor" --conectamos las tablas con el nombre de los actores y de las categorías correspondientes con varios left join
on "actor"."actor_id"="film_actor"."actor_id"
left join "film"
on "film_actor"."film_id"="film"."film_id"
left join "film_category"
on "film"."film_id"="film_category"."film_id"
left join "category"
on "film_category"."category_id"="category"."category_id"
where "category"."name"='Action'
group by CONCAT ("actor"."first_name", ' ', "actor"."last_name") --lo filtramos para que no aparezcan actores repetidos
order by actores_de_accion asc ;--lo ordenamos alfabéticamente para facilitar la búsqueda

--**************************************************************

--46. Encuentra todos los actores que no han participado en películas.
select CONCAT ("actor"."first_name", ' ', "actor"."last_name") as actores_sin_peliculas
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
where "film_id" is null;

--si las tablas son mas grandes, usar not exists agiliza el proceso
SELECT CONCAT("actor"."first_name", ' ', "actor"."last_name") AS actores_sin_peliculas
FROM "actor"
WHERE NOT EXISTS (
    SELECT 1
    FROM "film_actor"
    WHERE "film_actor"."actor_id" = "actor"."actor_id"
);
--en esta versión no hace falta que explicitemos la condición de film_id ya que esta versión busca coincidencias 
-- entre los actor id en ambas tablas


--**************************************************************

--47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select CONCAT ("actor"."first_name", ' ', "actor"."last_name") as actores, COUNT("film_actor"."film_id") as numero_peliculas
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
group by CONCAT ("actor"."first_name", ' ', "actor"."last_name")
;

--**************************************************************

--48. Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
create view actor_num_peliculas as --usamos la funcion create view y usamos el código anterior
select CONCAT ("actor"."first_name", ' ', "actor"."last_name") as actores, COUNT("film_actor"."film_id") as numero_peliculas
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
group by CONCAT ("actor"."first_name", ' ', "actor"."last_name");

--**************************************************************

--49. Calcula el número total de alquileres realizados por cada cliente.
select CONCAT("customer"."first_name", ' ', "customer"."last_name") as nombre_cliente, COUNT("rental_id") as numero_alquileres 
from "customer"
left join "rental"
on "customer"."customer_id"="rental"."customer_id"
group by CONCAT("customer"."first_name", ' ', "customer"."last_name")
order by nombre_cliente; --ordenamos a los clientes por orden alfabético para facilitar las búsquedas

--**************************************************************

--50. Calcula la duración total de las películas en la categoría 'Action'.
--no entendía muy bien si con el enunciado se refería a calcular la duración total de cada película de acción
--(en cuyo caso usaríamos esta query)
select "film"."title" as peliculas_accion, "film"."length" as duración_peliculas_acción
from "film"
left join "film_category"
on "film"."film_id"="film_category"."film_id"
left join "category"
on "film_category"."category_id"="category"."category_id"
where "category"."name"='Action'
group by "film"."title","film"."length" ;

--o si se refería a sumar la duración de todas las películas y obtener así una duración total
--(en cuyo caso) usaría la query anterior como subconsulta
select SUM(duracion_peliculas_accion) as duracion_total_peliculas_accion
from (select "film"."title" as peliculas_accion, "film"."length" as duracion_peliculas_accion
      from "film" 
      left join "film_category"
      on "film"."film_id"="film_category"."film_id"
      left join "category"
      on "film_category"."category_id"="category"."category_id"
      where "category"."name"='Action'
      group by "film"."title","film"."length"
);

--**************************************************************

--51. Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.

create temporary TABLE cliente_rentas_temporal as --creamos la tabla temporal
select CONCAT("customer"."first_name", ' ', "customer"."last_name") as nombre_cliente, COUNT("rental"."rental_id") as total_alquileres 
from "customer"
left join "rental"
on "customer"."customer_id"="rental"."customer_id"
group by CONCAT("customer"."first_name", ' ', "customer"."last_name");

--**************************************************************

--52. Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.

create temporary table peliculas_alquiladas as --creamos la tabla temporal
select "film"."title" as peliculas_alquiladas_al_menos_10_veces , COUNT("rental"."rental_id")
from "film"
left join "inventory"
on "film"."film_id"="inventory"."film_id"
left join "rental"
on "inventory"."inventory_id"="rental"."inventory_id"
group by "film"."title"
having COUNT("rental"."rental_id") >10 --usamos having porque tenemos la función count
;
      
--**************************************************************

--53. Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ 
--y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película.

select "film"."title"
from "film"
left join "inventory"
on "film"."film_id"="inventory"."film_id"
left join "rental"
on "inventory"."inventory_id"="rental"."inventory_id"
left join "customer"
on "rental"."customer_id"="customer"."customer_id"
where "customer"."first_name"='TAMMY' and "customer"."last_name"='SANDERS' and "rental"."return_date" is null;

--conectamos las tablas de customer y film con los correspondientes left join y finalmente filtramos usando la condición
--buscada. La imponemos en el nombre, apellido y fecha de devolución (que debe ser nula si son películas que no ha devuelto)

--**************************************************************

--54.Encuentra los nombres de los actores que han actuado en al menos una 
--película que pertenece a la categoría ‘Sci-Fiʼ. Ordena los resultados 
--alfabéticamente por apellido.

select CONCAT ("actor"."first_name", ' ', "actor"."last_name") as actores_de_Sci_fi
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
left join "film"
on "film_actor"."film_id"="film"."film_id"
left join "film_category"
on "film"."film_id"="film_category"."film_id"
left join "category"
on "film_category"."category_id"="category"."category_id"
where "category"."name"='Sci-Fi' --seleccionamos a todos los actores que han participado en alguna película de sci-fi
order by "actor"."last_name" asc; --ordenamos por orden alfabético según el apellido


--**************************************************************
--55. Encuentra el nombre y apellido de los actores que han actuado en 
--películas que se alquilaron después de que la película ‘Spartacus 
--Cheaperʼ se alquilara por primera vez. Ordena los resultados 
--alfabéticamente por apellido.
select "actor"."first_name" as nombre_del_actor, "actor"."last_name" as apellido_del_actor 
from "actor"
left join "film_actor"
on "actor"."actor_id"="film_actor"."actor_id"
left join "film"
on "film_actor"."film_id"="film"."film_id"
where "title" in (                                 --queremos el nombre de los actores cuando el título de las películas en las que salen hayan sido alquiladas después de una determinada fecha
        select "title"
        from "film"
        left join "inventory"
        on "film"."film_id"="inventory"."film_id"
        left join "rental"
        on "inventory"."inventory_id"="rental"."inventory_id"
        where "rental"."rental_date">(             --abrimos una subconsulta donde hayamos la fecha en la que se alquiló por primera vez la película SPARTACUS CHEAPER
                       select "rental_date"
                       from "rental"
                       left join "inventory"
                       on "rental"."inventory_id"="inventory"."inventory_id"
                       left join "film"
                       on "inventory"."film_id"="film"."film_id"
                       where "film"."title"='SPARTACUS CHEAPER'
                       order by "rental_date" asc
                       limit 1)
            )
group by "actor"."first_name", "actor"."last_name" --agrupamos para que no aparezcan nombres repetidos
order by "actor"."last_name" asc;                   --ordenamos por apellido
                       
               
--**************************************************************
--56. Encuentra el nombre y apellido de los actores que no han actuado en 
--ninguna película de la categoría ‘Musicʼ.

select CONCAT ("actor"."first_name", ' ', "actor"."last_name") as actores_no_music --elegimos el nombre de los actores
from "actor"
where not exists(     -- si no hay ninguna peli que cumpla la condición que viene, nos lo devuelve, si existe al menos una peli con la categoria music la subconsulta devuelve una fila y el not exists devuelve falso
select 1 --lo usamos porque queremos saber si existe alguna fila que cumpla la condición
from "film_actor"
join "film" on "film_actor"."film_id"="film"."film_id"
join "film_category" on "film"."film_id"="film_category"."film_id"
join "category" on "film_category"."category_id"="category"."category_id"
where "film_actor"."actor_id"="actor"."actor_id" and "category"."name"='Music') --elegimo la primera condición para 'relacionar' las tablas de actor y de film_actor




--**************************************************************
--57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select "title"
from "film"
where "rental_duration">8;

--al ejecutar la query anterior no devuelve nada así que he comprobado con esta query que la mayor duración de alquiler han sido 7 días
select "rental_duration"
from "film"
order by "rental_duration" desc; --lo ordenamos de forma descendente para ver cuál es el mayor número


--**************************************************************
--58. Encuentra el título de todas las películas que son de la misma categoría 
--que ‘Animationʼ.
select "title" as películas_de_animación
from "film"
left join "film_category"
on "film"."film_id"="film_category"."film_id"
left join "category"
on "film_category"."category_id"="category"."category_id"
where "category"."name"='Animation'
group by "title";

--**************************************************************
--59. Encuentra los nombres de las películas que tienen la misma duración 
--que la película con el título ‘Dancing Feverʼ. Ordena los resultados 
--alfabéticamente por título de película.
select "title" as peliculas_con_misma_duracion_que_Dancing_Fever
from "film"
where "length"=(     --queremos que la duracion de las peliculas que escogemos sea 
       select "length"    --la duracion de la pelicula Dancing Fever
       from "film"
       where "title"='DANCING FEVER')
order by  peliculas_con_misma_duracion_que_Dancing_Fever asc;

--**************************************************************
--60. Encuentra los nombres de los clientes que han alquilado al menos 7 
--películas distintas. Ordena los resultados alfabéticamente por apellido.
select "customer"."first_name" as nombres_clientes_asiduos, "customer"."last_name" as apellidos_clientes_asiduos
from "customer"
left join "rental"
on "customer"."customer_id"="rental"."customer_id"
left join "inventory"
on "rental"."inventory_id"="inventory"."inventory_id"
group by "customer"."first_name", "customer"."last_name"
having COUNT(distinct("film_id"))>6 --queremos tener en cuenta solo las peliculas distintas
order by apellidos_clientes_asiduos; --ordenamos por apellido

--**************************************************************
--61. Encuentra la cantidad total de películas alquiladas por categoría y 
--muestra el nombre de la categoría junto con el recuento de alquileres.
select "category"."name" as Categoría_de_película ,COUNT("rental"."rental_id") as numero_películas_alquiladas
from "category"
left join "film_category"
on "category"."category_id"="film_category"."category_id"
left join "film"
on "film_category"."film_id"="film"."film_id"
left join "inventory"
on "film"."film_id"="inventory"."film_id"
left join "rental"
on "inventory"."inventory_id"="rental"."inventory_id"
group by "category"."name"
order by Categoría_de_película; --lo ordenamos para una mayor claridad


--**************************************************************
--62. Encuentra el número de películas por categoría estrenadas en 2006.
select "category"."name" as Categoría_de_película ,COUNT("film"."film_id") as numero_películas_estrenadas_2006
from "category"
left join "film_category"
on "category"."category_id"="film_category"."category_id"
left join "film"
on "film_category"."film_id"="film"."film_id"
where "release_year"=2006 --queremos las estrenadas en 2006
group by "category"."name"
order by Categoría_de_película;
 
 --**************************************************************
--63. Obtén todas las combinaciones posibles de trabajadores con las tiendas 
--que tenemos.
select CONCAT("staff"."first_name", ' ', "staff"."last_name") as nombre_trabajador, "store"."store_id"
from "staff"
cross join "store"; 
--usamos cross join (hace el producto cartesiano de las tablas) para ver todas las combinaciones posibles
--aquí puede ser útil puesto que no tenemos muchos trabajadores ni tiendas

--**************************************************************
--64. Encuentra la cantidad total de películas alquiladas por cada cliente y 
--muestra el ID del cliente, su nombre y apellido junto con la cantidad de 
--películas alquiladas.
select "customer"."customer_id", CONCAT("customer"."first_name", ' ',  "customer"."last_name") as nombre_cliente, COUNT ("rental"."rental_id") as numero_peliculas_alquiladas
from "customer"
left join "rental"
on "customer"."customer_id"="rental"."customer_id"
group by "customer"."customer_id",CONCAT("customer"."first_name", ' ',  "customer"."last_name")
order by "customer_id"; --lo ordenamos para mayor comodidad al buscar a los clientes en la tabla
