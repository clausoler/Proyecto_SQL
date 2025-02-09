--Sección 1. Consultas SQL iniciales
 
--2. Muestra los nombres de todas las películas con una clasificación por edades de ‘R’.
 
select "title" as "nombre_películas"
from "film" as "f"
where "rating" = 'R';
 
--3. Encuentra los nombres de los actores con actor_id entre 30 y 40.
select concat("first_name", '', "last_name") as "actores", "actor_id"
from "actor" as "a"
where "actor_id" between 30 and 40;
 
--4. Obtén las películas cuyo idioma coincide con el idioma original.
select "title" as "películas"
from "film" as "f"
where "language_id" = "original_language_id";
 
--5. Ordena las películas por duración de forma ascendente.
select "title" as "películas", "length" as "duración"
from "film" as "f"
order by "length" asc;
 
--6. Encuentra el nombre y apellido de los actores con ‘Allen’ en su apellido.
select "first_name" as "nombre", "last_name" as "apellido"
from "actor" as "a"
where "last_name" like '%Allen%';
 
--7. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento.
select "rating" as "clasificación", count (*) as "cantidad_pelis"
from "film" as "f"
group by "rating";

--8. Encuentra el título de todas las películas que son ‘PG13’ o tienen una duración mayor a 3 horas.
select "title" as "películas"
from "film" as "f"
WHERE "rating" = 'PG-13' OR "length" > 180;
 
--9. Encuentra la variabilidad de lo que costaría reemplazar las películas.
select stddev("replacement_cost") as "desviación", variance("replacement_cost") as "duración"
from "film" as "f";
 
--10. Encuentra la mayor y menor duración de una película en la base de datos.
select max("length") as "duración_max", min("length") as "duración_min"
from "film" as "f";
 
--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.
select "amount" as "costo_alquiler"
from "payment" as "p"
order by "payment_date" desc
limit 1
offset 2;
 
--12. Encuentra el título de las películas que no sean ni ‘NC-17’ ni ‘G’ en cuanto a clasificación.
select "title" as "películas"
from "film" as "f"
where "rating" not in ('NC-17', 'G');
 
--13. Encuentra el promedio de duración de las películas para cada clasificación y muestra la clasificación junto con el promedio.
select avg("length") as "duración_pelis", "rating" as "clasificación_pelis"
from "film" as "f" 
group by "rating";
 
--14. Encuentra el título de todas las películas con una duración mayor a 180 minutos.
select "title" as "películas"
from "film" as "f"
where "length" > 180;
 
--15. ¿Cuánto dinero ha generado en total la empresa?
select sum("amount") as "total_ingresos"
from "payment" as "p";
 
--16. Muestra los 10 clientes con mayor valor de ID.
select concat("first_name", ' ', "last_name") as "clientes"
from "customer" as "c"
order by "customer_id" desc 
limit 10;
 
--17. Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’.
select concat(a."first_name", ' ', a."last_name") as "actores"
from "actor" as "a"
inner join "film_actor" as "fa"
on a."actor_id" = fa."actor_id"
inner join "film" as "f"
on fa."film_id" = f."film_id" 
where f."title" = 'Egg Igby';
 
--Sección 2. Consultas intermedias
 
--1. Selecciona todos los nombres únicos de películas.
select distinct "title" as "nombres_únicos"
from "film" as "f";
 
--2. Encuentra las películas que son comedias y tienen una duración mayor a 180 minutos.
select f."title" as "películas" 
from "film" as "f" 
inner join "film_category" as "fc" 
on f."film_id" = fc."film_id"
inner join "category" as "c"
on c."category_id" = fc."category_id"
where c."name" = 'Comedy' and f."length" > 180;

--3. Encuentra las categorías de películas con un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio.
select c."name" as "categoría", avg(f."length") as "duración"
from "category" as "c"
inner join "film_category" as "fc"
on c."category_id" = fc."category_id"
inner join "film" as "f"
on f."film_id" = fc."film_id"
group by c."name"
having avg(f."length") > 110;

--4. ¿Cuál es la media de duración del alquiler de las películas?
select justify_interval(avg("return_date" - "rental_date")) as "duración_media"
from "rental" as "r"
where "return_date" is not null;
 
--5. Crea una columna con el nombre completo (nombre y apellidos) de los actores y actrices.
select concat("first_name", ' ', "last_name") as "actores"
from "actor" as "a";

--6. Muestra los números de alquileres por día, ordenados de forma descendente.
select "rental_date" as "fecha_alquileres", count (*) as "cantidad_alquileres"
from "rental" as "r"
group by "rental_date"
order by "cantidad_alquileres"desc;
 
--7. Encuentra las películas con una duración superior al promedio.
select "title" as "películas"
from "film" as "f"
where "length" > (select avg("length") from "film" as "f");
 
--8. Averigua el número de alquileres registrados por mes.
select date_trunc('month', "rental_date") as "mes", count(*) as "número_alquileres"
from "rental" as "r"
group by "mes"
order by "mes";
 
--9. Encuentra el promedio, la desviación estándar y la varianza del total pagado.
select avg("amount"), stddev("amount"), variance("amount")
from "payment" as "p"; 
 
--10. ¿Qué películas se alquilan por encima del precio medio?
select f."title" AS "películas", f."rental_rate" AS "precio_alquiler"
from "film" as "f"
where f."rental_rate" > (select AVG("rental_rate") from "film" as "f")
order by f."rental_rate" DESC;
 
--11. Muestra el ID de los actores que hayan participado en más de 40 películas.
select "actor_id", count("film_id") as "total_películas"
from "film_actor" as "fa"
group by "actor_id"
having count("film_id") > 40
order by "total_películas"desc;
 
--12. Obtén todas las películas y, si están disponibles en el inventario, muestra la cantidad disponible.
select f."film_id", 
       f."title" AS "películas", 
       COUNT(i."inventory_id") AS "cantidad_disponible"
from "film" as "f"
left join "inventory" as "i"
on f."film_id" = i."film_id"
left join "rental" as "r" 
on i."inventory_id" = r."inventory_id" AND r."return_date" IS NULL
group by f."film_id", f."title"
order by "cantidad_disponible" DESC;
 
--13. Obtén los actores y el número de películas en las que han actuado.
select concat("first_name", ' ', "last_name") as "actores", count(fa."film_id") as "total_películas"
from "actor" as "a"
inner join "film_actor" as "fa"
on a."actor_id" = fa."actor_id"
group by "actores"
order by "total_películas"desc;
 
--14. Obtén todas las películas con sus actores asociados, incluso si algunas no tienen actores.
select f."title" as "películas", concat(a."first_name", ' ', a."last_name") as "actores"
from "film" as "f"
left join "film_actor" as "fa"
on f."film_id" =fa."film_id"
left join "actor" as "a"
on a."actor_id" = fa."actor_id"
order by "actores";

--15. Encuentra los 5 clientes que más dinero han gastado.
select concat(c."first_name", ' ', c."last_name") as "clientes", sum(p."amount") as "total_gastado"
from "customer" as "c"
inner join "payment" as "p"
on c."customer_id" = p."customer_id"
group by "clientes"
order by "total_gastado"desc
limit 5;
 
--Sección 3. Consultas avanzadas

--1. Encuentra el ID del actor más bajo y más alto.
select concat("first_name", ' ', "last_name") as "actor", "actor_id"
from "actor" as "a"
where "actor_id" in ((select min("actor_id") from "actor" as "a"), (select max("actor_id") from "actor" as "a"));
 
--2. Cuenta cuántos actores hay en la tabla actor.
select count("actor_id")
from "actor" as "a";
 
--3. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select "first_name" as "nombre_actor", "last_name" as "apellido_actor"
from "actor" as "a"
order by "apellido_actor";
 
--4. Selecciona las primeras 5 películas de la tabla film.
select "title" as "películas"
from "film" as "f"
limit 5;
 
--5. Agrupa los actores por nombre y cuenta cuántos tienen el mismo nombre.
select "first_name", count(*) as "total_actores"
from "actor" as "a"
group by "first_name" 
having count(*) > 1
order by "total_actores"desc;
 
--6. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r."rental_id", 
       r."rental_date", 
       c."customer_id", 
       concat(c."first_name", ' ', c."last_name") AS "nombre_cliente"
from "rental" as "r"
inner join "customer" as "c" 
on r."customer_id" = c."customer_id"
order by r."rental_date" DESC;
 
--7. Muestra todos los clientes y sus alquileres, incluyendo los que no tienen.
select c."customer_id", 
       concat(c."first_name", ' ', c."last_name") AS "nombre_cliente", 
       r."rental_id", 
       r."rental_date"
from "customer" as "c"
left join "rental" as "r" 
on c."customer_id" = r."customer_id"
order by c."customer_id", r."rental_date";

--8. Realiza un CROSS JOIN entre las tablas film y category. Analiza su valor.
select f."title" as "pelicula",
       c."name" as "categoria"
from "film" as "f"
cross join "category" as "c"
order by f."title", c."name";
 
-- Lo que ocurre aquí es que el cross join combina cada película con cada categoría. Por tanto, si hay 100 películas y 10 categorías,
-- cada película aparecerá 10 veces, una por cada categoría. Y cada categoría aparecerá 100 veces, una por cada película.
-- Esto no tiene sentido porque no hay una relación de categorías real. Para ello habría que hacer un inner join. 
 
--9. Encuentra los actores que han participado en películas de la categoría ‘Action’.
select concat(a."first_name", ' ', a."last_name") as "actores"
from "actor" as "a"
inner join "film_actor" as "fa" 
on a."actor_id" = fa."actor_id"
inner join "film" as "f" 
on fa."film_id" = f."film_id"
join "film_category" as "fc" 
ON f."film_id" = fc."film_id"
inner join "category" as "c" 
on fc."category_id" = c."category_id"
where c."name" = 'Action'
order by "actores";
 
--10. Encuentra todos los actores que no han participado en películas.
select concat(a."first_name", ' ', a."last_name") as "actores"
from "actor" as "a"
left join "film_actor" as "fa" 
on a."actor_id" = fa."actor_id"
where fa."actor_id" IS NULL
order by "actores";
 
--11. Crea una vista llamada actor_num_peliculas que muestre los nombres de los actores y el número de películas en las que han actuado.
create view "actor_num_peliculas" as
select a."actor_id", 
       concat(a."first_name", ' ', a."last_name") as "nombre_actores", 
       count(fa."film_id") as "total_peliculas"
from "actor" as "a"
left join "film_actor" as "fa" 
on a."actor_id" = fa."actor_id"
group by a."actor_id", a."first_name", a."last_name"
order by "total_peliculas" DESC;

SELECT * FROM "actor_num_peliculas";
 
--Seccióm 4. Consultas con tablas temporales

--1. Calcula el número total de alquileres realizados por cada cliente.
with "alquileres_totales" as (
    select 
        concat(c."first_name", ' ', c."last_name") as "cliente",
        count(r."rental_id") as "total_alquileres"
    from "customer" as "c"
    left join "rental" as "r" 
    on c."customer_id" = r."customer_id"
    group by "cliente"
)
select * 
from "alquileres_totales"
order by "total_alquileres" DESC;
 
--2. Calcula la duración total de las películas en la categoría Action.
WITH peliculas_action AS (
    SELECT film.film_id, film.title, film.length
    FROM film
    JOIN film_category ON film.film_id = film_category.film_id
    JOIN category ON film_category.category_id = category.category_id
    WHERE category.name = 'Action'
)
SELECT SUM(length) AS duracion_total_minutos
FROM peliculas_action;
 
--3. Encuentra los clientes que alquilaron al menos 7 películas distintas.
with "clientes_con_peliculas" as (
    select r."customer_id", 
           concat(c."first_name", ' ', c."last_name") AS "nombre_cliente", 
           count(DISTINCT i."film_id") as "total_peliculas_alquiladas"
    from "rental" as "r"
    inner join "inventory" as "i" 
    on r."inventory_id" = i."inventory_id"
    inner join "customer" as "c" 
    on r."customer_id" = c."customer_id"
    group by r."customer_id", c."first_name", c."last_name"
)
select * 
from "clientes_con_peliculas"
where "total_peliculas_alquiladas" >= 7
order by "total_peliculas_alquiladas" DESC;

 
--4. Encuentra la cantidad total de películas alquiladas por categoría.
with "alquileres_por_categoria" as (
    select c."name" as "categoria", 
           count(r."rental_id") as "total_alquileres"
    from "rental" as "r"
    inner join "inventory" as "i" 
    on r."inventory_id" = i."inventory_id"
    inner join "film" as "f" 
    on i."film_id" = f."film_id"
    inner join "film_category" as "fc" 
    on f."film_id" = fc."film_id"
    inner join "category" as "c" 
    on fc."category_id" = c."category_id"
    group by c."name"
)
select * 
from "alquileres_por_categoria"
order by "total_alquileres" DESC;
 
--5. Renombra las columnas first_name como Nombre y last_name como Apellido.
with "actores" as (
    select "first_name" as "Nombre", 
           "last_name" as "Apellido"
    from "actor"
)
select * from "actores";

--6.1. Crea una tabla temporal llamada cliente_rentas_temporal para almacenar el total de alquileres por cliente.
create temp table "cliente_rentas_temporal" (
    "customer_id" INT PRIMARY KEY,
    "nombre_completo" TEXT,
    "total_alquileres" INT
);

INSERT INTO cliente_rentas_temporal (customer_id, nombre_completo, total_alquileres)
SELECT c.customer_id, 
       CONCAT(c.first_name, ' ', c.last_name) AS nombre_completo,
       COUNT(r.rental_id) AS total_alquileres
FROM customer c
LEFT JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_alquileres DESC;

SELECT * FROM cliente_rentas_temporal;

--6.2. Crea otra tabla temporal llamada peliculas_alquiladas para almacenar películas alquiladas al menos 10 veces.
CREATE TEMP TABLE peliculas_alquiladas (
    film_id INT PRIMARY KEY,
    titulo TEXT,
    total_alquileres INT
);

INSERT INTO peliculas_alquiladas (film_id, titulo, total_alquileres)
SELECT f.film_id, 
       f.title AS titulo, 
       COUNT(r.rental_id) AS total_alquileres
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.film_id, f.title
HAVING COUNT(r.rental_id) >= 10
ORDER BY total_alquileres DESC;

SELECT * FROM peliculas_alquiladas;
 
--7. Encuentra los nombres de los clientes que más gastaron y sus películas asociadas.
WITH total_gasto_clientes AS (
    SELECT p.customer_id, 
           CONCAT(c.first_name, ' ', c.last_name) AS nombre_cliente,
           SUM(p.amount) AS total_gastado
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    GROUP BY p.customer_id, c.first_name, c.last_name
    ORDER BY total_gastado DESC
    LIMIT 5
)
SELECT tgc.nombre_cliente, 
       f.title AS pelicula, 
       tgc.total_gastado
FROM total_gasto_clientes tgc
JOIN rental r ON tgc.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
ORDER BY tgc.total_gastado DESC, tgc.nombre_cliente, f.title;


--8. Encuentra los actores que actuaron en películas de la categoría Sci-Fi.
WITH actores_sci_fi AS (
    SELECT DISTINCT a.actor_id, 
           CONCAT(a.first_name, ' ', a.last_name) AS nombre_completo
    FROM actor a
    JOIN film_actor fa ON a.actor_id = fa.actor_id
    JOIN film f ON fa.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name = 'Sci-Fi'
)
SELECT * FROM actores_sci_fi
ORDER BY nombre_completo;








 



