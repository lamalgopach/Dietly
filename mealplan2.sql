--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.13
-- Dumped by pg_dump version 9.5.13

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE ONLY public.users_diets DROP CONSTRAINT users_diets_user_id_fkey;
ALTER TABLE ONLY public.users_diets DROP CONSTRAINT users_diets_diet_id_fkey;
ALTER TABLE ONLY public.users_allergies DROP CONSTRAINT users_allergies_user_id_fkey;
ALTER TABLE ONLY public.users_allergies DROP CONSTRAINT users_allergies_allergy_id_fkey;
ALTER TABLE ONLY public.recipes_ingredients DROP CONSTRAINT recipes_ingredients_recipe_id_fkey;
ALTER TABLE ONLY public.recipes_ingredients DROP CONSTRAINT recipes_ingredients_ingredient_id_fkey;
ALTER TABLE ONLY public.plans DROP CONSTRAINT plans_user_id_fkey;
ALTER TABLE ONLY public.plans_recipes DROP CONSTRAINT plans_recipes_recipe_id_fkey;
ALTER TABLE ONLY public.plans_recipes DROP CONSTRAINT plans_recipes_plan_id_fkey;
ALTER TABLE ONLY public.diets_recipes DROP CONSTRAINT diets_recipes_recipe_id_fkey;
ALTER TABLE ONLY public.diets_recipes DROP CONSTRAINT diets_recipes_diet_id_fkey;
ALTER TABLE ONLY public.allergies_recipes DROP CONSTRAINT allergies_recipes_recipe_id_fkey;
ALTER TABLE ONLY public.allergies_recipes DROP CONSTRAINT allergies_recipes_allergy_id_fkey;
ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY public.users_diets DROP CONSTRAINT users_diets_pkey;
ALTER TABLE ONLY public.users_allergies DROP CONSTRAINT users_allergies_pkey;
ALTER TABLE ONLY public.recipes DROP CONSTRAINT recipes_pkey;
ALTER TABLE ONLY public.recipes_ingredients DROP CONSTRAINT recipes_ingredients_pkey;
ALTER TABLE ONLY public.plans_recipes DROP CONSTRAINT plans_recipes_pkey;
ALTER TABLE ONLY public.plans DROP CONSTRAINT plans_pkey;
ALTER TABLE ONLY public.ingredients DROP CONSTRAINT ingredients_pkey;
ALTER TABLE ONLY public.diets_recipes DROP CONSTRAINT diets_recipes_pkey;
ALTER TABLE ONLY public.diets DROP CONSTRAINT diets_pkey;
ALTER TABLE ONLY public.allergies_recipes DROP CONSTRAINT allergies_recipes_pkey;
ALTER TABLE ONLY public.allergies DROP CONSTRAINT allergies_pkey;
ALTER TABLE public.users_diets ALTER COLUMN user_diet_id DROP DEFAULT;
ALTER TABLE public.users_allergies ALTER COLUMN user_allergy_id DROP DEFAULT;
ALTER TABLE public.users ALTER COLUMN user_id DROP DEFAULT;
ALTER TABLE public.recipes_ingredients ALTER COLUMN recipe_ingredient_id DROP DEFAULT;
ALTER TABLE public.recipes ALTER COLUMN recipe_id DROP DEFAULT;
ALTER TABLE public.plans_recipes ALTER COLUMN recipe_plan_id DROP DEFAULT;
ALTER TABLE public.plans ALTER COLUMN plan_id DROP DEFAULT;
ALTER TABLE public.ingredients ALTER COLUMN ingredient_id DROP DEFAULT;
ALTER TABLE public.diets_recipes ALTER COLUMN diet_recipe_id DROP DEFAULT;
ALTER TABLE public.diets ALTER COLUMN diet_id DROP DEFAULT;
ALTER TABLE public.allergies_recipes ALTER COLUMN allergy_recipe_id DROP DEFAULT;
ALTER TABLE public.allergies ALTER COLUMN allergy_id DROP DEFAULT;
DROP SEQUENCE public.users_user_id_seq;
DROP SEQUENCE public.users_diets_user_diet_id_seq;
DROP TABLE public.users_diets;
DROP SEQUENCE public.users_allergies_user_allergy_id_seq;
DROP TABLE public.users_allergies;
DROP TABLE public.users;
DROP SEQUENCE public.recipes_recipe_id_seq;
DROP SEQUENCE public.recipes_ingredients_recipe_ingredient_id_seq;
DROP TABLE public.recipes_ingredients;
DROP TABLE public.recipes;
DROP SEQUENCE public.plans_recipes_recipe_plan_id_seq;
DROP TABLE public.plans_recipes;
DROP SEQUENCE public.plans_plan_id_seq;
DROP TABLE public.plans;
DROP SEQUENCE public.ingredients_ingredient_id_seq;
DROP TABLE public.ingredients;
DROP SEQUENCE public.diets_recipes_diet_recipe_id_seq;
DROP TABLE public.diets_recipes;
DROP SEQUENCE public.diets_diet_id_seq;
DROP TABLE public.diets;
DROP SEQUENCE public.allergies_recipes_allergy_recipe_id_seq;
DROP TABLE public.allergies_recipes;
DROP SEQUENCE public.allergies_allergy_id_seq;
DROP TABLE public.allergies;
DROP EXTENSION plpgsql;
DROP SCHEMA public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: allergies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.allergies (
    allergy_id integer NOT NULL,
    allergy_name character varying NOT NULL
);


--
-- Name: allergies_allergy_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.allergies_allergy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: allergies_allergy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.allergies_allergy_id_seq OWNED BY public.allergies.allergy_id;


--
-- Name: allergies_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.allergies_recipes (
    allergy_recipe_id integer NOT NULL,
    recipe_id integer,
    allergy_id integer
);


--
-- Name: allergies_recipes_allergy_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.allergies_recipes_allergy_recipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: allergies_recipes_allergy_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.allergies_recipes_allergy_recipe_id_seq OWNED BY public.allergies_recipes.allergy_recipe_id;


--
-- Name: diets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diets (
    diet_id integer NOT NULL,
    diet_name character varying NOT NULL
);


--
-- Name: diets_diet_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diets_diet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diets_diet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diets_diet_id_seq OWNED BY public.diets.diet_id;


--
-- Name: diets_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.diets_recipes (
    diet_recipe_id integer NOT NULL,
    recipe_id integer,
    diet_id integer
);


--
-- Name: diets_recipes_diet_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.diets_recipes_diet_recipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: diets_recipes_diet_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.diets_recipes_diet_recipe_id_seq OWNED BY public.diets_recipes.diet_recipe_id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingredients (
    ingredient_id integer NOT NULL,
    ingredient_name character varying NOT NULL
);


--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ingredients_ingredient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ingredients_ingredient_id_seq OWNED BY public.ingredients.ingredient_id;


--
-- Name: plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plans (
    plan_id integer NOT NULL,
    plan_name character varying NOT NULL,
    user_id integer,
    calories double precision NOT NULL,
    carbohydrates double precision NOT NULL,
    fat double precision NOT NULL,
    protein double precision NOT NULL
);


--
-- Name: plans_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plans_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plans_plan_id_seq OWNED BY public.plans.plan_id;


--
-- Name: plans_recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.plans_recipes (
    recipe_plan_id integer NOT NULL,
    plan_id integer,
    recipe_id integer
);


--
-- Name: plans_recipes_recipe_plan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.plans_recipes_recipe_plan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: plans_recipes_recipe_plan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.plans_recipes_recipe_plan_id_seq OWNED BY public.plans_recipes.recipe_plan_id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipes (
    recipe_id integer NOT NULL,
    recipe_name character varying NOT NULL,
    recipe_url character varying NOT NULL,
    recipe_image character varying,
    directions text NOT NULL,
    servings double precision NOT NULL,
    calories double precision NOT NULL,
    carbohydrates double precision NOT NULL,
    fat double precision NOT NULL,
    protein double precision NOT NULL
);


--
-- Name: recipes_ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.recipes_ingredients (
    recipe_ingredient_id integer NOT NULL,
    recipe_id integer,
    ingredient_id integer,
    amount double precision
);


--
-- Name: recipes_ingredients_recipe_ingredient_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recipes_ingredients_recipe_ingredient_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_ingredients_recipe_ingredient_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recipes_ingredients_recipe_ingredient_id_seq OWNED BY public.recipes_ingredients.recipe_ingredient_id;


--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.recipes_recipe_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.recipes_recipe_id_seq OWNED BY public.recipes.recipe_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    user_id integer NOT NULL,
    fname character varying NOT NULL,
    lname character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL
);


--
-- Name: users_allergies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_allergies (
    user_allergy_id integer NOT NULL,
    user_id integer,
    allergy_id integer
);


--
-- Name: users_allergies_user_allergy_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_allergies_user_allergy_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_allergies_user_allergy_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_allergies_user_allergy_id_seq OWNED BY public.users_allergies.user_allergy_id;


--
-- Name: users_diets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_diets (
    user_diet_id integer NOT NULL,
    user_id integer,
    diet_id integer
);


--
-- Name: users_diets_user_diet_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_diets_user_diet_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_diets_user_diet_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_diets_user_diet_id_seq OWNED BY public.users_diets.user_diet_id;


--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_user_id_seq OWNED BY public.users.user_id;


--
-- Name: allergy_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergies ALTER COLUMN allergy_id SET DEFAULT nextval('public.allergies_allergy_id_seq'::regclass);


--
-- Name: allergy_recipe_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergies_recipes ALTER COLUMN allergy_recipe_id SET DEFAULT nextval('public.allergies_recipes_allergy_recipe_id_seq'::regclass);


--
-- Name: diet_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets ALTER COLUMN diet_id SET DEFAULT nextval('public.diets_diet_id_seq'::regclass);


--
-- Name: diet_recipe_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets_recipes ALTER COLUMN diet_recipe_id SET DEFAULT nextval('public.diets_recipes_diet_recipe_id_seq'::regclass);


--
-- Name: ingredient_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN ingredient_id SET DEFAULT nextval('public.ingredients_ingredient_id_seq'::regclass);


--
-- Name: plan_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans ALTER COLUMN plan_id SET DEFAULT nextval('public.plans_plan_id_seq'::regclass);


--
-- Name: recipe_plan_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans_recipes ALTER COLUMN recipe_plan_id SET DEFAULT nextval('public.plans_recipes_recipe_plan_id_seq'::regclass);


--
-- Name: recipe_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes ALTER COLUMN recipe_id SET DEFAULT nextval('public.recipes_recipe_id_seq'::regclass);


--
-- Name: recipe_ingredient_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes_ingredients ALTER COLUMN recipe_ingredient_id SET DEFAULT nextval('public.recipes_ingredients_recipe_ingredient_id_seq'::regclass);


--
-- Name: user_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN user_id SET DEFAULT nextval('public.users_user_id_seq'::regclass);


--
-- Name: user_allergy_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_allergies ALTER COLUMN user_allergy_id SET DEFAULT nextval('public.users_allergies_user_allergy_id_seq'::regclass);


--
-- Name: user_diet_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_diets ALTER COLUMN user_diet_id SET DEFAULT nextval('public.users_diets_user_diet_id_seq'::regclass);


--
-- Data for Name: allergies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.allergies (allergy_id, allergy_name) FROM stdin;
1	Gluten
2	Wheat
3	Tree-Nuts
4	Shellfish
5	Soy
6	Eggs
7	Milk
\.


--
-- Name: allergies_allergy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.allergies_allergy_id_seq', 1, false);


--
-- Data for Name: allergies_recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.allergies_recipes (allergy_recipe_id, recipe_id, allergy_id) FROM stdin;
1	41	1
2	41	2
3	51	1
4	51	2
5	55	2
6	56	1
7	56	2
8	62	1
9	62	2
10	63	1
11	63	2
12	64	1
13	64	2
14	67	1
15	67	2
16	68	1
17	68	2
18	69	1
19	69	2
\.


--
-- Name: allergies_recipes_allergy_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.allergies_recipes_allergy_recipe_id_seq', 19, true);


--
-- Data for Name: diets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.diets (diet_id, diet_name) FROM stdin;
1	Alcohol-Free
2	Peanut-Free
3	Sugar-Conscious
4	Tree-Nut-Free
5	Vegan
6	Vegetarian
7	High-Protein
8	Low-Carb
9	Low-Fat
10	Balanced
\.


--
-- Name: diets_diet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.diets_diet_id_seq', 1, false);


--
-- Data for Name: diets_recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.diets_recipes (diet_recipe_id, recipe_id, diet_id) FROM stdin;
1	1	2
2	1	4
3	1	1
4	1	8
5	2	3
6	2	2
7	2	4
8	2	1
9	2	8
10	3	3
11	3	2
12	3	4
13	3	1
14	3	8
15	4	3
16	4	2
17	4	4
18	4	1
19	5	2
20	5	1
21	6	6
22	6	2
23	6	4
24	6	1
25	6	10
26	7	6
27	7	2
28	7	4
29	7	1
30	7	9
31	8	3
32	8	6
33	8	2
34	8	4
35	8	1
36	9	3
37	9	6
38	9	2
39	9	4
40	9	1
41	10	6
42	10	2
43	10	4
44	10	1
45	10	10
46	11	3
47	11	2
48	11	4
49	11	1
50	11	8
51	12	3
52	12	6
53	12	2
54	12	4
55	12	1
56	12	8
57	13	3
58	13	2
59	13	4
60	13	1
61	13	8
62	14	3
63	14	6
64	14	2
65	14	4
66	14	1
67	14	8
68	15	3
69	15	6
70	15	2
71	15	4
72	15	1
73	15	8
74	16	3
75	16	2
76	16	4
77	16	1
78	16	8
79	17	3
80	17	2
81	17	4
82	17	8
83	18	2
84	18	4
85	18	1
86	18	8
87	19	2
88	19	4
89	19	1
90	19	8
91	20	3
92	20	4
93	20	1
94	20	7
95	20	8
96	21	3
97	21	6
98	21	2
99	21	4
100	21	1
101	21	8
102	22	3
103	22	5
104	22	6
105	22	2
106	22	4
107	22	1
108	22	9
109	23	3
110	23	5
111	23	6
112	23	2
113	23	4
114	23	1
115	23	9
116	24	5
117	24	6
118	24	2
119	24	4
120	24	1
121	24	8
122	25	3
123	25	5
124	25	6
125	25	2
126	25	4
127	25	1
128	26	6
129	26	4
130	26	1
131	27	6
132	27	2
133	27	4
134	27	1
135	27	9
136	28	5
137	28	6
138	28	2
139	28	4
140	28	1
141	28	9
142	29	6
143	29	2
144	29	4
145	29	1
146	30	6
147	30	2
148	30	1
149	30	10
150	31	5
151	31	6
152	31	2
153	31	4
154	31	1
155	31	10
156	32	3
157	32	5
158	32	6
159	32	2
160	32	4
161	32	1
162	32	10
163	33	3
164	33	5
165	33	6
166	33	2
167	33	4
168	33	1
169	33	10
170	34	3
171	34	6
172	34	2
173	34	4
174	34	1
175	34	10
176	35	6
177	35	2
178	35	4
179	35	1
180	36	3
181	36	2
182	36	4
183	36	1
184	36	8
185	37	3
186	37	5
187	37	6
188	37	2
189	37	4
190	37	1
191	38	6
192	38	2
193	38	4
194	38	1
195	39	2
196	39	4
197	39	1
198	39	10
199	40	3
200	40	2
201	40	4
202	40	1
203	40	10
204	41	6
205	41	2
206	41	4
207	41	1
208	41	8
209	42	5
210	42	6
211	42	2
212	42	4
213	42	1
214	42	9
215	43	5
216	43	6
217	43	2
218	43	4
219	43	1
220	43	9
221	44	3
222	44	6
223	44	2
224	44	4
225	44	1
226	44	8
227	45	5
228	45	6
229	45	2
230	45	4
231	45	1
232	45	9
233	46	3
234	46	5
235	46	6
236	46	2
237	46	4
238	46	1
239	46	8
240	47	3
241	47	5
242	47	6
243	47	2
244	47	4
245	47	1
246	47	8
247	48	3
248	48	5
249	48	6
250	48	2
251	48	4
252	48	1
253	48	8
254	49	5
255	49	6
256	49	2
257	49	4
258	49	1
259	50	3
260	50	6
261	50	2
262	50	4
263	50	1
264	51	6
265	51	2
266	51	1
267	51	8
268	52	6
269	52	2
270	52	4
271	52	1
272	52	10
273	53	6
274	53	2
275	53	4
276	53	1
277	54	3
278	54	5
279	54	6
280	54	2
281	54	4
282	54	1
283	54	8
284	55	6
285	55	2
286	55	4
287	55	9
288	56	6
289	56	2
290	56	4
291	57	6
292	57	2
293	57	4
294	57	1
295	57	9
296	58	6
297	58	2
298	58	4
299	58	1
300	58	10
301	59	2
302	59	4
303	59	1
304	60	5
305	60	6
306	60	2
307	60	4
308	60	1
309	60	10
310	61	3
311	61	6
312	61	2
313	61	4
314	61	1
315	61	9
316	62	6
317	62	2
318	62	4
319	62	1
320	62	9
321	63	2
322	63	4
323	63	1
324	64	3
325	64	6
326	64	2
327	64	4
328	64	1
329	65	2
330	65	4
331	65	1
332	66	6
333	66	2
334	66	4
335	66	1
336	67	6
337	67	2
338	67	4
339	67	1
340	67	10
341	68	6
342	68	2
343	68	4
344	68	1
345	68	10
346	69	6
347	69	2
348	69	4
349	69	1
350	70	5
351	70	6
352	70	2
353	70	1
354	70	8
355	71	3
356	71	5
357	71	6
358	71	2
359	71	4
360	71	1
361	71	8
362	72	2
363	72	1
364	72	8
365	73	3
366	73	2
367	73	4
368	73	1
369	73	7
370	73	8
371	74	3
372	74	2
373	74	4
374	74	1
375	75	2
376	75	4
377	75	1
378	75	8
379	76	6
380	76	2
381	76	4
382	76	1
383	77	6
384	77	2
385	77	4
386	77	1
387	78	6
388	78	2
389	78	4
390	78	1
391	78	10
392	79	3
393	79	2
394	79	4
395	79	1
396	79	10
397	80	3
398	80	6
399	80	2
400	80	4
401	80	1
402	80	10
403	81	3
404	81	6
405	81	2
406	81	4
407	81	1
408	81	8
409	82	6
410	82	2
411	82	4
412	82	1
413	83	3
414	83	6
415	83	2
416	83	4
417	83	1
418	83	8
419	84	3
420	84	2
421	84	4
422	85	2
423	85	4
424	85	1
425	85	8
426	86	6
427	86	2
428	86	4
429	86	1
430	86	10
431	87	3
432	87	6
433	87	2
434	87	4
435	87	1
\.


--
-- Name: diets_recipes_diet_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.diets_recipes_diet_recipe_id_seq', 435, true);


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ingredients (ingredient_id, ingredient_name) FROM stdin;
1	1 sheet puff pastry, thawed
2	2 tablespoons maple syrup, plus more for serving
3	18 cooked breakfast sausages, about 1 pound
4	1 egg
5	1/2 cup cooked breakfast potatoes, seasoned to taste
6	2 eggs , beaten
7	1 thick slice smoked beef brisket, chopped
8	2 tablespoons jack cheese, shredded
9	1 flour tortilla
10	2 tablespoons salsa
11	4 Tablespoons Butter, More If Needed
12	1/2 whole Medium Yellow Onion, Sliced
13	1/4 pound Breakfast Sausage (Jimmy Dean, JC Potter, Etc)
14	2 whole Eggs, Beaten
15	3 slices Cheddar, Swiss, Provolone, Or Other Cheese
16	2 slices Bread (sourdough, Rye, Whole Wheat, Etc.)
17	1/2 pound breakfast sausage (about 10 links)
18	10 ounces button mushrooms, finely chopped
19	4 sprigs thyme
20	1/2 cup grated sharp Cheddar cheese
21	1 pound puff pastry, thawed if frozen
22	1 egg, beaten
23	Kosher salt and freshly ground black pepper
24	Hot English or Dijon mustard for serving
25	Asparagus pesto breakfast tart
26	1 sheet puff pastry, thawed
27	3 strips of bacon
28	2 tbs butter
29	2 tsp pesto
30	1 roasted red pepper, chopped (jarred is fine)
31	3 asparagus spears
32	6 eggs
33	½ tsp pepper
34	½ cup parmesan cheese
35	4 basil leaves, chopped
36	2 cups all-purpose flour
37	2 teaspoons baking powder
38	1 teaspoon baking soda
39	1/2 teaspoon kosher salt, or slightly less table salt
40	3 tablespoons sugar
41	2 large eggs, lightly beaten
42	3 cups buttermilk
43	4 tablespoons unsalted butter, melted, plus 1 tablespoon extra for brushing griddle (I've made these pancakes with and without the butter mixed in, and can say with confidence they work either way. They're just richer with it, of course.)
44	1 cup blueberries, fresh or frozen and thawed (optional)
45	6 cups white whole wheat flour
46	1/3 cup sugar
47	2 tablespoons baking powder
48	1 tablespoon baking soda
49	2 teaspoons salt
50	1 large egg, whisked
51	1 cup buttermilk
52	1 tablespoon vegetable or canola oil
53	1 cup pancake mix (above)
54	140.0g roasted peppers , in oil from a jar or the deli, drained
55	Three quarters of a 200.0g tub low-fat soft cheese
56	140.0g roasted aubergines , in oil from a jar or the deli, drained
57	About 24 basil leaves
58	8 pancakes (see recipe link below)
59	1 cup pancake mix
60	2 Tbsp water
61	¾ cup apple pie filling
62	1 tsp allspice
63	3 Tbsp butter
64	1 tsp cinnamon
65	1 tsp maple syrup
66	oil for frying
67	6 cups all-purpose flour
68	1 1/2 teaspoons baking soda (check expiration date first)
69	3 teaspoons baking powder
70	1 tablespoon kosher salt
71	2 tablespoons sugar
72	2 eggs, separated
73	2 cups buttermilk
74	4 tablespoons melted butter
75	2 cups "instant" pancake mix, recipe above
76	1 stick butter, for greasing the pan
77	2 cups fresh fruit such as blueberries, if desired
78	Vegetable oil or butter, for the muffin tin
79	6 large eggs (choose eggs of a very similar size)
80	2 tablespoons chopped, slightly undercooked bacon (figure 2 slices)
81	1/4 cup grated Parmesan (optional)
82	Salt and freshly ground black pepper, to taste
83	2 eggs
84	2 pieces good white bread
85	5 tablespoons sweet butter
86	8 eggs
87	8 slices bacon
88	4 large eggs
89	2 tablespoons heavy cream
90	Coarse salt and freshly ground pepper
91	2 tablespoons unsalted butter
92	6 hard boiled eggs
93	3-4 tbsps plain yogurt
94	½ tsp minced preserved lemon
95	Pinch salt and white pepper
96	1/2 cup (125ml) mirin
97	1/2 cup (125ml) soy sauce
98	One 2-inch (5cm) piece of fresh ginger, peeled and grated
99	2-pounds (900g) boneless chicken thighs (4-8 thighs, depending on size)
100	1/2 cup olive oil
101	5 cloves garlic, peeled
102	2 large russet potatoes, peeled and cut into chunks
103	1 3-4 pound chicken, cut into 8 pieces (or 3 pound chicken legs)
104	3/4 cup white wine
105	3/4 cup chicken stock
106	3 tablespoons chopped parsley
107	1 tablespoon dried oregano
108	Salt and pepper
109	1 cup frozen peas, thawed
110	1/2 cup water
111	2 tablespoons Japanese soy sauce
112	2 tablespoons dark brown sugar
113	2 tablespoons mirin
114	4-6 skin-on filleted (boneless) chicken thighs
115	2 tablespoons mild flavored honey (or maltose)
116	2 tablespoons dark soy sauce
117	2 tablespoons sake
118	1 tbsp. vegetable oil
119	4 pieces chicken, trimmed, skin pierced with a fork
120	½ cup Teriyaki Sauce
240	Freshly ground pepper
121	100.0ml soy sauce (Kikkoman is good)
122	4.0 tbsp smooth peanut butter
123	4 skinless chicken breasts fillets
124	1 bunch of medium sized asparagus, about 1 lb
125	2 Tbsp of the most exquisite extra virgin olive oil
126	2 Tbsp freshly grated Parmesan cheese (omit if cooking vegan)
127	1 teaspoon lemon zest
128	Salt and freshly ground black pepper
129	Salt
130	2 pounds asparagus, trimmed
131	1 lemon, halved
132	Freshly ground black pepper
133	1 pound jumbo asparagus, trimmed
134	Coarse salt
135	1 lb. fresh asparagus
136	2 tbsp. vegetable oil
137	2 bunches (about 2 pounds total) asparagus, ends trimmed
138	1 tablespoon olive oil
139	Kosher salt, to taste
140	1/2 banana
141	1 tablespoon natural peanut butter
142	1 cup ice cold skim milk
143	1 ripe banana
144	1 cup frozen blueberries
145	1 cup nonfat plain yogurt
146	1 tablespoon sugar
147	1 cup water
148	1/2 piece lime
149	1 piece ripe yellow banana
150	1½ cups (210 g) flour
151	1 teaspoon baking powder (I always use Rumford)
152	½ teaspoon baking soda
153	½ teaspoon salt
154	1 teaspoon ground cinnamon
155	¾ cup (150 g) sugar
156	2 tablespoons (55 g) melted butter (salted or unsalted)
157	1 large egg white
158	1 large egg, at room temperature
159	1 cup (250 ml) banana puree, made from about 2 very ripe medium-sized bananas
160	½ cup (125 ml) sour cream, regular or low-fat (I used fromage blanc)
161	1/3 cup (60 g) chocolate chips or 3 tablespoons (30 g) cocoa nibs
162	6.0 tbsp greek-style yogurt
163	1 large banana , sliced
164	50.0g plain chocolate , melted
165	50.0g muesli
166	1 garlic clove, peeled and smashed
167	1 cup large green pitted olives
168	1 tablespoon capers, rinsed and drained
169	1 15-ounce can of artichoke hearts, drained
170	1/4 cup extra-virgin olive oil
171	8 large slices of crusty bread
172	1 cup cider vinegar
173	1 teaspoon salt
174	7 fresh or dried bay leaves
175	6 strips fresh lemon zest
176	3 cups frozen quartered artichoke hearts (about one and a half 9-ounce packages)
177	3/4 teaspoon hot pepper flakes
178	Extra virgin olive oil
179	1 tablespoon olive oil
180	2 garlic cloves, minced
181	4 plum tomatoes, halved lengthwise and sliced crosswise into 1/2-inch pieces
182	1 can (14 ounces) artichoke hearts, drained and halved
183	Coarse salt and ground pepper
184	olive oil
185	1 lemon , juiced and zested
186	25.0g parmesan , finely grated
187	150.0g spaghetti
188	100.0g marinated artichoke hearts , drained and sliced
189	½ small bunch basil , shredded
190	8 ½"-thick slices ciabatta or another peasant-style bread
191	Extra-virgin olive oil
192	1 garlic clove, smashed
193	½ cup mascarpone
194	1 6½oz. jar marinated artichoke hearts
195	2 tbsp. finely chopped chives
196	2 oz. parmesan, shaved thin with a peeler
197	Freshly ground black pepper, to taste
198	12 slices thick-cut, applewood-smoked bacon
199	1 batch Pizza Dough
200	1/2 cup crème fraîche
201	1 cup Caramelized Onions
202	8 large eggs
203	2 cups shredded part-skim mozzarella cheese
204	1 Basic Pizza Dough
205	sugar
206	oil
207	500 g bread flour(3 3/4 cups)
208	2 1/2 tsp Dry Yeast instant or active (10 grams)
209	3/4 tsp Table Salt(5 grams)
210	3/4 tsp Sugar, plus a pinch (about 3 grams)
211	1 1/2 cup water at room temperature
212	extra-virgin olive oil for pans
213	2 x yellow onions(medium), finely chopped (pizza cipolla)
214	1/3 cup Heavy Cream(pizza cipolla)
215	1 tsp Kosher Salt(pizza cipolla)
216	2 tsp fresh thyme, coarsely chopped(pizza cipolla)
217	7 oz diced tomatoes, drained(pizza pomodoro)
218	3/4 cup Canned Tomatoes (reserved juice) (pizza pomodoro)
219	2 tsp Extra Virgin Olive Oil(pizza pomodoro)
220	1/2 tsp Kosher Salt(pizza pomodoro)
221	1 pinch Red Pepper Flakes(pizza pomodoro)
222	8 x fresh basil (large leaves), chopped(pizza pomodoro)
223	1/2 pound flour
224	1/2-ounce bakers yeast
225	1 tablespoon water to blend yeast
226	1 tablespoon olive oil, plus extra to dampen pizza at end
227	Salt and pepper
228	1 egg
229	1/4 cup hot water
230	2 (1 pound 12-ounce) tins or 3 pounds fresh egg-shaped tomatoes, skinned, seeded and roughly chopped
231	2 teaspoons capers
232	1/2 small tin anchovies in oil, drained
233	5 slices mozzarella cheese
234	10 black olive halves
235	1 sprig oregano
236	1 small garlic clove, finely sliced
237	Freshly ground black pepper, for garnish
238	12 ounces prepared pizza dough. (see my blog for recipe)
239	2-3 whole lemons, ends removed and discarded, sliced paper thin
241	Extra-virgin olive oil
242	1/4 cup créme fraîche
243	4 ounces smoked salmon
244	600 gs zucchini sliced into 1/8
245	1 tsp salt
246	100 gs gruyere cheese shredded
247	2 tsps potato starch
248	1/8 tsp ground nutmeg
249	1/2 cup heavy cream
250	6 cups Champagne vinegar
251	1 1/2 cups granulated sugar
252	1/2 cup salt
253	3 teaspoons celery seeds
254	3 teaspoons turmeric powder
255	1 teaspoon dry mustard powder
256	2 yellow onions, julienned
257	5 pounds zucchini, unpeeled, thinly sliced with a mandoline
258	1 pound zucchini (medium-smallish)
259	1 small yellow onion
260	3 tablespoons kosher salt
261	2 cups apple cider vinegar
262	1 cup sugar (I would try 3/4 cup)
263	1 1/2 teaspoons dry mustard
264	1 1/2 teaspoons crushed yellow and/or brown mustard seeds
265	scant 1 teaspoon ground turmeric
266	1 pound medium zucchini
267	1 large baking potato (3/4 pound), peeled
268	1 small onion (4 ounces), peeled
269	1/2 cup matzo meal
270	1 large egg, lightly beaten
271	1 teaspoon fresh lemon juice
272	1 1/2 teaspoons salt
273	1/2 teaspoon freshly ground pepper
274	Vegetable oil, for frying
275	3 medium zucchini (1 pound/16 oz/450 g), thinly sliced
276	1 medium white onion, thinly sliced
277	3 shallots, thinly sliced
278	1 1/2 tablespoons fine grain sea salt
279	1/4 cup (small handful) fresh dill sprigs
280	1 small fresh red chile pepper, very thinly sliced
281	1/2 tablespoon yellow mustard seeds
282	3/4 cup/180 ml cider vinegar
283	3/4 cup/180 ml white wine vinegar
284	1/3 cup/1.75 oz/50g natural cane sugar
285	4 pounds broccoli rabe
286	1/3 cup olive oil
287	4 cloves garlic, coarsely chopped
288	Salt and freshly ground black pepper
289	3 bag broccoli florets
290	3 tbsp. olive oil
291	3 clove garlic
292	1 tsp. grated fresh lemon peel
293	salt and pepper
294	1 pound broccoli rabe, washed and trimmed
295	2 teaspoons salt
296	2 tablespoons olive oil, divided
297	1 teaspoon red pepper flakes
298	3 teaspoons fresh lemon juice
299	2 heads broccoli
300	2 tablespoons olive oil
301	1/2 teaspoon celtic sea salt
302	900.0g trimmed broccoli , divided into florets
303	25.0g butter
304	50.0g parmesan , grated, plus extra to serve
305	1/3 cup chopped dry-packed sun-dried tomatoes
306	1/4 cup barbecue sauce
307	3 tablespoons balsamic vinegar
308	1 (about 1 1/4 pounds) eggplant
309	1/4 cup basil oil or extra-virgin olive oil
310	8 ounces sliced smoked provolone
311	3 tablespoons finely chopped shallot or red onion
312	1/4 cup finely chopped pecan pieces
313	1-2 cups milk
314	A handful of strawberries, rinsed, stems removed
315	1 to 3 Tbsp honey
316	2 or 3 slices of bread, cut into quarters
317	1 cup cornflake cereal
318	2 large eggs
319	1/3 cup milk
320	1/2 teaspoon all-purpose flour
321	2 drops of vanilla
322	Butter and pancake syrup
323	3 Tbs. extra-virgin olive oil; more as needed
324	Kosher salt
325	1 large globe eggplant (about 1 lb.), trimmed and cut into 1/2-inch-thick rounds
326	2 1/2 cups grappa or unflavored vodka
327	2 cups whole milk
328	2 cups sugar
329	2 ounces bittersweet chocolate (preferably 70%), grated
330	1/2 lemon, seeded and chopped, with rind
331	5 cups of a mixture of whole milk and half-and-half (4:1 is suggested, but I might go more like 3:2 next time)
332	1 1/2 cups bourbon, another whiskey or brandy
333	1 cup powdered sugar, sifted
334	1 tablespoon vanilla extract
335	2 3/4 cups Corn Flakes
336	3 3/4 cups cold milk, preferably whole milk
337	2 tablespoons packed light brown sugar
338	1/4 teaspoon kosher salt
339	Canola oil or other neutral oil
340	1 medium eggplant (aubergine)
341	1 large onion, cut lengthways then into thin half moons
342	2 tsp ginger, grated
343	3 x cloves garlic, grated
344	1 small green chili, sliced finely
345	1/2 cup cilantro leaves, coarsely chopped
346	salt to taste
347	2 c. coffee
348	1 c. oat-bran hot cereal
349	1 c. pancake mix
350	1/4 cup old-fashioned oats
351	1/4 cup puffed rice cereal
352	1/4 cup puffed wheat cereal
353	1 1/2 tablespoons sugar-free pancake syrup
354	1/2 cup bite-size freeze-dried apples
355	Serving suggestion: fat-free vanilla yogurt and fresh berries
356	4 tbsp butter
357	10 oz homemade marshmallows
358	6 cup crispy rice cereal
359	1/4 tsp salt
360	2 1/4 teaspoons yeast
361	1 cup lukewarm water
362	11 1/4 ounces (about 2 cups) bread flour
363	2 teaspoons vanilla extract
364	4 tablespoons butter, divided
365	1/2 cup erewhon brown rice cereal
366	1 tablespoon cinnamon
367	Nonstick cooking spray
368	4 tablespoons unsalted butter
369	1 bag (10 ounces) marshmallows
370	1/2 teaspoon salt
371	6 cups toasted oat cereal
372	1 cup dried cranberries, or raisins
373	3 cups Corn Flakes, or other unsweetened cereal (such as Special K, Chex, etc)
374	2 1/2 cups whole milk
375	1 1/2 cups heavy cream
376	2/3 cup brown sugar
377	1/4 teaspoon fine sea salt
378	4 egg yolks
379	1 teaspoon vanilla
380	2 cups Corn Flakes, or your unsweetened cereal of choice
381	1/4 cup water
382	3/4 cup oat flour (you can make this by pulsing rolled oats into a food processor or spice grinder until finely ground; 1 cup of oats yielded 3/4 cup oat flour for me)
383	1 cup all-purpose flour
384	2 teaspoon baking powder
385	3/4 teaspoon Kosher or coarse salt
386	3 tablespoons unsalted butter, melted and cooled slightly (plus extra for the pan)
387	1 1/4 cups whole milk
388	1 cup cooked oatmeal*
389	1 tablespoon unsulphured (not blackstrap) molasses or 1 tablespoon honey
390	1 cup milk (i use skim)
391	1 1-inch knob of ginger, peeled and sliced thin
392	5 cardamom pods
393	1 cinnamon stick
394	4 black peppercorns
395	2/3 cups oatmeal
396	1 and 1/2 orange, juice only
397	1/2 lemon, juice only
398	1/2 small red onion, chopped
399	1/4 cup extra virgin olive oil
400	1/8 teaspoon fine grain salt
401	4 big handfuls of salad greens, washed and dried
402	1/2 cup walnut halves, toasted
403	1/3 cup black olives, (the wrinkly, oily ones), pitted
404	6 to 8 cups fresh salad greens: red or green leaf lettuce, romaine hearts, arugula, watercress, spinach, or frisée, or a mixture
405	1/4 cup Classic Vinaigrette (see note), plus more for passing
406	2 medium red onions
407	8 slices pancetta or bacon
408	A couple of glugs olive oil
409	4 sprigs fresh thyme, leaves removed
410	Handful of pinenuts (about 1/4 cup)
411	Pinch of salt
412	4 big handfuls of arugula or any nice salad leaves
413	Balsamic vinegar (up to 1/4 cup or so)
414	Chunk of Parmesan cheese
415	1 whole (about 12 pounds) turkey
416	2 tablespoons kosher salt
417	2 tablespoons coarsely ground black pepper
418	1/4 cup butter
419	1/4 cup flour
420	4 cups turkey drippings or turkey stock
421	1 1/2 dinner rolls, torn into bite-sized pieces (or about ¾ cup of any torn bread)
422	2 teaspoons white wine vinegar
423	¼ teaspoon smoked paprika
424	¼ teaspoon salt
425	pinch red pepper flakes
426	about 1 ½ cups halved cherry tomtaoes
427	2 tablespoons crumbled feta
428	4 cups very crisp cornflakes or other non-sugar-coated flaked cereal
429	1 pound bittersweet chocolate, tempered
430	2 15-ounce cans black beans, drained and well-rinsed
431	4 bell peppers, a mix of colors, chopped into a small dice
432	1/2 super-large or 1 medium white onion, chopped into a small dice
433	Juice of one lime
434	3 tablespoons olive oil
435	1 teaspoon ground cumin
436	3/4 teaspoon salt
437	1/2 teaspoon honey
438	1/8 teaspoon cayenne
439	2 tablespoons light butter, softened
440	1 tablespoon minced fresh chives
441	Pinch black pepper
442	4 whole-wheat dinner rolls
443	1/4 cup warm water (115 degrees)
444	2 packets (1/4 ounce each) active dry yeast
445	1 1/2 cups warm whole milk (115 degrees)
446	1/2 cup (1 stick) unsalted butter, melted, plus more for bowl and pans
447	1/4 cup sugar
448	2 1/4 teaspoons salt
449	3 large eggs
450	6 to 6 1/2 cups all-purpose flour (spooned and leveled), plus more for work surface
451	6 x hard boiled eggs
452	2 small green onions, finely chopped
453	3 tbsp mayonnaise
454	Salt and pepper to taste
455	1 box potato and onion pierogi
456	1 bag fresh broccoli florets
457	1 tub light Alfredo sauce
458	½ c. drained roasted red pepper strips
459	¼ c. shredded Cheddar
460	1/8 teaspoon Kosher salt (a pinch of salt per egg)
461	1/4 cup grated Gruyere cheese
462	2 or so pounds biala kielbasa
463	1 1/2 tablespoons fat (I like a combination of unsalted butter and grapeseed oil)
464	3/4 cup water, wine, or beer (I used Żywiec Porter)
465	1 pound fresh pierogi, about 12
466	1 pound sauerkraut, drained and rinsed
467	2 tablespoons ketchup*
468	1/2 cup water or low-salt chicken stock
469	5 juniper berries
470	4 1/2-inch thick slices of stale ciabatta or other stale crusty bread
471	3 medium-large tomatoes, coarsely chopped
472	3 ounces fresh mozzarella, diced
473	1 tablespoon extra virgin olive oil
474	1 1/2 tablespoon balsamic vinegar
475	Salt and freshly ground pepper, to taste
476	Handful of fresh basil leaves
477	1 basic pizza dough, divided into 6 pieces
478	1/3 cup yellow cornmeal
479	2 tablespoons extra-virgin olive oil
480	1 basic italian tomato sauce
481	1 pound fresh mozzarella, sliced thin
482	36 fresh basil leaves, washed and dried
\.


--
-- Name: ingredients_ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ingredients_ingredient_id_seq', 482, true);


--
-- Data for Name: plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.plans (plan_id, plan_name, user_id, calories, carbohydrates, fat, protein) FROM stdin;
1	p1	1	1000	125	27.7777777777777786	62.5
2	p1	1	1300	70	70	70
3	p1	1	1500	200	200	200
4	p1	1	2300	140	140	140
5	p3	1	1600	200	53.3333333333333357	80
6	p1	1	1600	140	44.4444444444444429	120
7	p1	1	1600	120	100	100
8	p1	1	1800	80	80	80
9	p1	1	1800	225	60	112.5
10	p1	1	1600	90	60	20
11	p1	1	1800	19	15	12
12	p1	1	1800	30	30	30
13	pmilion	1	1600	200	53.3333333333333357	80
14	pmilion	1	1600	200	53.3333333333333357	80
15	pmilion	1	1600	200	53.3333333333333357	80
16	pmilion	1	1600	200	53.3333333333333357	80
17	pmilion	1	1600	200	53.3333333333333357	80
18	pmilion	1	1600	200	53.3333333333333357	80
19	pmilion	1	1600	200	53.3333333333333357	80
20	p1	1	2000	250	66.6666666666666714	100
21	m1	2	1500	187.5	50	75
22	m2	2	1800	150	75	55
23	p1	2	1800	225	60	90
24	p1	2	1800	225	60	90
25	p1	2	1800	225	60	90
26	p1	2	1800	225	60	90
27	p1	2	1800	225	60	90
28	p1	2	1800	225	60	90
29	p1	2	1800	225	60	90
30	p1	2	1800	225	60	90
31	p1	2	1800	225	60	90
32	p1	2	1800	225	60	90
33	p1	2	1800	225	60	90
34	p1	2	1800	225	60	90
35	p1	2	1800	225	60	90
36	b1	3	1900	237.5	63.3333333333333357	95
37	b1	3	1900	237.5	63.3333333333333357	95
38	b1	3	1900	237.5	63.3333333333333357	95
39	1500	4	2200	275	61.1111111111111143	137.5
40	1500	5	1500	187.5	41.6666666666666643	93.75
41	p5	5	1800	225	50	112.5
42	z1500	5	1800	225	50	112.5
43	1900	5	1900	237.5	52.7777777777777786	118.75
44	1500	6	1900	237.5	52.7777777777777786	118.75
45	o1	7	1900	237.5	52.7777777777777786	118.75
46	k1	7	1900	237.5	63.3333333333333357	95
47	k2	7	2300	287.5	76.6666666666666714	115
48	1800	7	1800	200	53	80
49	1900	8	1900	237.5	63.3333333333333357	95
50	60	8	2200	275	85.5555555555555571	82.5
51	2100	8	2100	200	100	100
52	p2	8	1500	70	70	70
53	2000	8	2000	150	100	100
54	p1	1	1900	50	30	20
55	2300	1	2300	140	140	140
56	1400	1	2300	80	80	80
57	2750	1	2750	63	200	138
58	j	9	2750	63	200	138
59	p1	9	1500	187.5	50	75
60	p1	9	1500	187.5	50	75
61	p1	1	2500	312.5	83.3333333333333286	156.25
62	plan3	16	2300	150	100	100
63	u2	17	2500	200	100	100
64	planxx	17	2500	200	100	100
65	p1	17	2500	200	100	100
66	2500	17	2500	200	100	100
67	b	18	2500	200	100	100
68	plan2	18	2300	140	140	140
69	plan2	18	2300	140	140	140
70	plan2	18	2300	140	140	140
71	plan2	18	2300	140	140	140
72	plan2	18	2300	140	140	140
73	plan2	18	2300	140	140	140
74	plan2	18	2300	140	140	140
75	plan2	18	2300	140	140	140
76	plan2	18	2300	140	140	140
77	plan2	18	2300	140	140	140
78	plan2	18	2300	140	140	140
79	plan2	18	2300	140	140	140
80	plan2	18	2300	140	140	140
81	plan2	18	2300	140	140	140
82	plan2	18	2300	140	140	140
83	plan2	18	2300	140	140	140
84	plan	10	2300	140	140	140
85	2300	10	2300	140	140	140
86	2300	10	2300	140	140	140
87	2300	10	2300	140	140	140
88	2300	10	2300	140	140	140
89	2300	10	2300	140	140	140
90	2300	10	2300	140	140	140
91	2300	10	2300	140	140	140
92	2300	10	2300	140	140	140
93	2300	10	2300	140	140	140
94	2300	10	2300	140	140	140
95	2300	10	2300	140	140	140
96	2300	10	2300	140	140	140
97		10	2300	140	140	140
98		10	2300	140	140	140
99		10	2300	140	140	140
100		10	2300	140	140	140
101		10	2300	140	140	140
102		10	2300	140	140	140
103		10	2300	140	140	140
104		10	2300	140	140	140
105		10	2300	140	140	140
106		10	2300	140	140	140
107		10	2300	140	140	140
108		10	2300	140	140	140
109		10	2300	140	140	140
110		10	2300	140	140	140
111		10	2300	140	140	140
112		10	2300	140	140	140
113		10	2300	140	140	140
114		10	2300	140	140	140
115		10	2300	140	140	140
116		10	2300	140	140	140
117		10	2300	140	140	140
118		10	2300	140	140	140
119		10	2300	140	140	140
120		10	2300	140	140	140
121		10	2300	140	140	140
122		10	2300	140	140	140
123		10	2300	140	140	140
124		10	2300	140	140	140
125		10	2300	140	140	140
126		10	2300	140	140	140
127		10	2300	140	140	140
128		10	2300	140	140	140
129		10	2300	140	140	140
130	23	10	2300	140	140	140
131	23	10	2300	140	140	140
132	23	10	2300	140	140	140
133	23	10	2300	140	140	140
134	23	10	2300	140	140	140
135	23	10	2300	140	140	140
136	23	10	2300	140	140	140
137	23	10	2300	140	140	140
138	23	10	2300	140	140	140
139	23	10	2300	140	140	140
140	23	10	2300	140	140	140
141	23	10	2300	140	140	140
142	23	10	2300	140	140	140
143	23	10	2300	140	140	140
144	23	10	2300	140	140	140
145	23	10	2300	140	140	140
146	23	10	2300	140	140	140
147	23	10	2300	140	140	140
148	23	10	2300	140	140	140
149	23	10	2300	140	140	140
150	23	10	2300	140	140	140
151	23	10	2300	140	140	140
152	Plan_test	10	2500	312.5	83.3333333333333286	125
153	Plan_test	10	2500	312.5	83.3333333333333286	125
154	2300	10	2300	140	140	140
155	gosia	10	2300	140	140	140
156	gosia	10	2300	140	140	140
157	gosia	10	2300	140	140	140
158	pla1	10	2300	140	140	140
159	pla1	10	2300	140	140	140
160	pla1	10	2300	140	140	140
161	pla1	10	2300	140	140	140
162	pla1	10	2300	140	140	140
163	pla1	10	2300	140	140	140
164	pla1	10	2300	140	140	140
165	pla1	10	2300	140	140	140
166	pla1	10	2300	140	140	140
167	pla1	10	2300	140	140	140
168	pla1	10	2300	140	140	140
169	pla1	10	2300	140	140	140
170	pla1	10	2300	140	140	140
171	pla1	10	2300	140	140	140
172	pla1	10	2300	140	140	140
173	pla1	10	2300	140	140	140
174	pla1	10	2300	140	140	140
175	pla1	10	2300	140	140	140
176	pla1	10	2300	140	140	140
177	pla1	10	2300	140	140	140
178	pla1	10	2300	140	140	140
179	pla1	10	2300	140	140	140
180	pla1	10	2300	140	140	140
181	pla1	10	2300	140	140	140
182	pla1	10	2300	140	140	140
183	pla1	10	2300	140	140	140
184	pla1	10	2300	140	140	140
185	pla1	10	2300	140	140	140
186	pla1	10	2300	140	140	140
187	pla1	10	2300	140	140	140
188	pla1	10	2300	140	140	140
189	pla1	10	2300	140	140	140
190	pla1	10	2300	140	140	140
191	pla1	10	2300	140	140	140
192	pla1	10	2300	140	140	140
193	pla1	10	2300	140	140	140
194	pla1	10	2300	140	140	140
195	pla1	10	2300	140	140	140
196	pla1	10	2300	140	140	140
197	pla1	10	2300	140	140	140
198	pla1	10	2300	140	140	140
199	pla1	10	2300	140	140	140
200	plan5	10	2300	230	51.1111111111111143	230
201	p2	10	2300	140	140	140
202	p2	10	2300	140	140	140
203	p2	10	2300	140	140	140
204	p1	10	2300	150	150	150
205	p1	10	2300	150	150	150
206	p1	10	2300	150	150	150
207	p1	10	2300	150	150	150
208	p1	10	2300	150	150	150
209	p1	10	2300	150	150	150
210	p1	10	2300	150	150	150
211	p1	10	2300	150	150	150
212	plan gosi	10	2300	140	140	140
213	plan gosi	10	2300	140	140	140
214	plan gosi	10	2300	140	140	140
215	plan gosi	10	2300	140	140	140
216	plan gosi	10	2300	140	140	140
217	plan gosi	10	2300	140	140	140
218	plan gosi	10	2300	140	140	140
219	plan gosi	10	2300	140	140	140
220	plan gosi	10	2300	140	140	140
221	plan gosi	10	2300	140	140	140
222	plan gosi	10	2300	140	140	140
223	plan gosi	10	2300	140	140	140
224	plan gosi	10	2300	140	140	140
225	plan gosi	10	2300	140	140	140
226	plan gosi	10	2300	140	140	140
227	plan gosi	10	2300	140	140	140
228	plan gosi	10	2300	140	140	140
229	plan gosi	10	2300	140	140	140
230	plan gosi	10	2300	140	140	140
231	plan gosi	10	2300	140	140	140
232	plan gosi	10	2300	140	140	140
233	plan gosi	10	2300	140	140	140
234	plan gosi	10	2300	140	140	140
235	plan gosi	10	2300	140	140	140
236	plan gosi	10	2300	140	140	140
237	pl2	10	2300	140	140	140
238	p1	10	2300	140	140	140
239	p1	10	2300	140	140	140
240	p1	10	2300	140	140	140
241	p1	10	2300	140	140	140
242	plan4	10	2300	140	140	140
243	plan4	10	2300	140	140	140
244	plan4	10	2300	140	140	140
245	plan4	10	2300	140	140	140
246	plan4	10	2300	140	140	140
247	plan4	10	2300	140	140	140
248	plan4	10	2300	140	140	140
249	plan4	10	2300	140	140	140
250	plan4	10	2300	140	140	140
251	plan4	10	2300	140	140	140
252	plan4	10	2300	140	140	140
253	plan4	10	2300	140	140	140
254	plan4	10	2300	140	140	140
255	plan4	10	2300	140	140	140
256	plan4	10	2300	140	140	140
257	plan4	10	2300	140	140	140
258	plan4	10	2300	140	140	140
259	plan_gosi	10	2300	140	60	70
260	plan4	10	1800	225	60	112.5
261	plan6	10	1300	162.5	50.5555555555555571	48.75
262	plan	10	2000	250	66.6666666666666714	100
263	plan	10	2000	250	66.6666666666666714	100
264	plan	10	2000	250	66.6666666666666714	100
265	plan	10	2000	250	66.6666666666666714	100
266	plan	10	2000	250	66.6666666666666714	100
267	plan	10	2000	250	66.6666666666666714	100
268	plan	10	2000	250	66.6666666666666714	100
269	plan_next	10	2000	250	66.6666666666666714	100
270	plan_gosia	10	2000	250	66.6666666666666714	100
271	plan_gosia	10	2000	250	66.6666666666666714	100
272	plan_gosia	10	2000	250	66.6666666666666714	100
273	plan_gosia	10	2000	250	66.6666666666666714	100
274	plan_gosia	10	2000	250	66.6666666666666714	100
275	plan_gosia	10	2000	250	66.6666666666666714	100
276	plan_gosia	10	2000	250	66.6666666666666714	100
277	plan_gosia	10	2000	250	66.6666666666666714	100
278	plan_gosia	10	2000	250	66.6666666666666714	100
279	plan_gosia	10	2000	250	66.6666666666666714	100
280	plan_gosia	10	2000	250	66.6666666666666714	100
281	plan_gosia	10	2000	250	66.6666666666666714	100
282	plan_gosia	10	2000	250	66.6666666666666714	100
283	gosia_plan	27	2300	287.5	76.6666666666666714	115
284	plan7	27	1600	140	140	140
285	plan_	27	1800	100	100	100
286	pla	27	2300	150	80	50
287	pla	27	2300	150	80	50
288	pla	27	2300	150	80	50
289	pla	27	2300	150	80	50
290	pla	27	2300	150	80	50
291	pla	27	2300	150	80	50
292	plan	27	2300	140	140	140
293	plan	27	2300	140	140	140
294	gosiaplan	10	2300	140	140	140
295	gosiaplan	10	2300	140	140	140
296	gosiaplan	10	2300	140	140	140
297	gosiaplan	10	2300	140	140	140
298	gosiaplan	10	2300	140	140	140
299	gosiaplan	10	2300	140	140	140
300	gosiaplan	10	2300	140	140	140
301	gosiaplan	10	2300	140	140	140
302	gosiaplan	10	2300	140	140	140
303	gosiaplan	10	2300	140	140	140
304	plan	10	2300	140	140	140
305	plan6	10	1590	40	120	80
306	plan6	10	1620	40	120	80
307	plan6	10	1620	80	60	80
308	p9	10	1750	80	50	40
309	p4	10	1650	60	40	30
310	p6	10	1650	80	40	30
311	plan1620	10	1620	240	60	50
312	plan1620	10	1620	240	60	50
313	plan1620	10	1620	240	60	50
314	plan1620	10	1620	240	60	50
315	plan1620	10	1620	240	60	50
316	plan1620	10	1620	240	60	50
317	plan1620	10	1620	240	60	50
318	bla	29	1620	240	60	50
322	4	33	1620	240	60	50
319	bla1	30	1620	240	60	50
320	1	31	1620	240	60	50
321	2	32	1620	240	60	50
323	1	31	2753	64	213	138
324	2753	31	2750	64	213	138
325	p	31	2750	64	213	138
326	p	31	2750	64	213	138
327	2	31	2750	64	213	138
328	p	31	2750	64	213	138
329	1	31	2750	64	213	138
330	plan	34	1620	240	60	50
331	bla	35	1620	240	60	50
332	plan_balanced	35	1700	200	110	100
333	pla	35	1700	200	80	70
334	balans	35	1700	200	100	100
335	1650	35	1650	200	100	100
336	1650	35	1650	200	90	90
337	p2	35	1650	200	80	80
338	p3	35	1650	200	80	85
339	p4	35	1680	190	70	85
340	p	35	1680	190	70	85
341	p	35	1680	190	70	85
342	p	35	1680	190	70	85
343	p1	35	1680	190	70	85
344		35	1700	212.5	56.6666666666666643	85
345	bla	35	1800	225	60	90
346		35	2000	50	35	15
347	1800	35	1800	225	60	90
348	1800	35	1800	225	60	90
349	p1	35	1800	225	60	90
350	user_plan1	36	1800	225	60	90
351	plan2	36	1680	190	70	85
352	plan1_Monday	37	1800	225	60	90
353	Plan2_Monday_better	37	1680	190	70	85
354	plan1	38	1800	225	60	90
355	plan2_Monday	38	1680	190	70	85
356	plan1_Monday	39	1800	225	60	90
357	Plan2_Monday	39	1680	190	70	85
358	plan1_Monday	40	1800	225	60	90
359	Plan2_Monday	40	1680	190	70	85
360	Monday	43	1800	225	60	90
361	Monday_new	43	1680	190	70	85
362	Plan_Monday	45	1800	225	60	90
363	Plan_Monday_new	45	1680	190	70	85
364	Plan_Monday	46	1800	225	60	90
365	Plan_Monday_new	46	1680	190	70	85
\.


--
-- Name: plans_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.plans_plan_id_seq', 365, true);


--
-- Data for Name: plans_recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.plans_recipes (recipe_plan_id, plan_id, recipe_id) FROM stdin;
1	4	4
2	4	51
3	4	52
4	58	3
5	58	1
6	58	2
7	60	53
8	63	53
9	63	54
10	63	55
11	83	16
12	83	43
13	83	2
14	83	18
15	83	2
16	83	38
17	84	38
18	84	2
19	84	18
20	84	38
21	84	2
22	84	18
23	84	43
24	84	16
25	84	2
26	86	16
27	86	43
28	86	2
29	87	43
30	87	2
31	87	16
32	90	18
33	90	2
34	90	38
35	91	2
36	91	38
37	91	18
38	92	43
39	92	16
40	92	2
41	149	53
42	151	53
43	151	51
44	151	54
45	151	51
46	151	55
47	154	43
48	154	16
49	154	2
50	155	38
51	155	18
52	155	2
53	203	16
54	203	43
55	203	2
56	211	53
57	211	51
58	211	56
59	241	53
60	241	51
61	241	57
62	241	58
63	243	59
64	243	53
65	256	53
66	258	53
67	258	60
68	258	52
69	261	59
70	261	53
71	261	54
72	261	56
73	262	61
74	262	53
75	262	62
76	266	63
77	266	64
78	266	65
79	266	66
80	267	67
81	267	68
82	267	69
83	268	65
84	268	70
85	268	71
86	268	72
87	268	73
88	268	74
89	268	75
90	268	71
91	268	76
92	268	63
93	268	65
94	269	65
95	269	72
96	269	76
97	282	17
98	282	7
99	282	32
100	282	17
101	282	7
102	282	32
103	293	77
104	293	78
105	293	79
106	294	77
107	294	71
108	303	66
109	303	78
110	303	80
111	303	76
112	303	76
113	304	77
114	304	78
115	304	79
116	342	81
117	342	82
118	342	82
119	342	82
120	342	76
121	343	81
122	343	82
123	343	76
124	344	83
125	345	83
126	345	84
127	345	76
128	348	83
129	348	21
130	348	49
131	348	76
132	348	85
133	348	85
134	348	87
135	349	81
136	349	49
137	349	87
138	350	83
139	350	49
140	350	87
141	351	7
142	351	13
143	351	18
144	352	81
145	352	49
146	352	87
147	353	24
148	353	18
149	353	7
150	354	81
151	354	49
152	354	87
153	355	3
154	355	83
155	355	7
156	356	81
157	356	49
158	356	87
159	357	7
160	357	3
161	357	46
162	358	81
163	358	49
164	358	87
165	359	81
166	359	3
167	359	7
168	360	81
169	360	49
170	360	87
171	361	3
172	361	7
173	361	81
174	362	81
175	362	49
176	362	87
177	363	7
178	363	3
179	363	50
180	364	81
181	364	49
182	364	87
183	365	7
184	365	3
185	365	50
\.


--
-- Name: plans_recipes_recipe_plan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.plans_recipes_recipe_plan_id_seq', 185, true);


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recipes (recipe_id, recipe_name, recipe_url, recipe_image, directions, servings, calories, carbohydrates, fat, protein) FROM stdin;
1	Breakfast Sausage Puffs recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_52b6ff20c3497382abcd97810d202a53	https://www.edamam.com/web-img/b88/b885ebf5e1816c0a37c7408f9dc51d65	http://www.marthastewart.com/868891/breakfast-sausage-puffs	4	2806.9399999999996	141.805599999999998	208.968300000000028	92.4667999999999921
2	The Wrangler Breakfast Taco recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_8aaf935a0992d5bf66c690cdf394f015	https://www.edamam.com/web-img/669/6690c340b7ac554d0cc194a53619b586	http://www.foodrepublic.com/recipes/the-wrangler-breakfast-taco-recipe/	4	5452.25523437306492	40.4918218749964751	423.756509374843006	346.29868749987304
3	Breakfast Patty Melt recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_da57ba7e791f6848a9f0607ab2f4d2d6	https://www.edamam.com/web-img/cd2/cd22b14330062e18fbdf3f41017d4bb9	http://thepioneerwoman.com/cooking/breakfast-patty-melt/	2	1376.58852547499987	36.8969822602499988	112.699627321500003	55.8123868172500011
4	Breakfast Sausage, Mushroom, and Cheddar Rolls Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_80ffa6f067ed26dd624de1afcc838448	https://www.edamam.com/web-img/e91/e916124a358d7f7bf72386b3c303ee13.jpg	http://www.seriouseats.com/recipes/2014/01/breakfast-sausage-mushroom-cheddar-roll-recipe.html	10	3590.43527421241288	222.239793721748129	259.239218623652278	100.290275410934626
5	Asparagus Pesto Breakfast Tart	http://www.edamam.com/ontologies/edamam.owl#recipe_81bc11c1dd8a3d745f6c2abf6fd2318c	https://www.edamam.com/web-img/9ab/9ab47aa80bedaa5affd8524cfe35b33e.jpg	http://honestcooking.com/asparagus-pesto-tart-recipe/	1	2570.67693820224713	122.462113876404501	193.78255550561795	83.3856050000000124
6	Blueberry Pancakes + Pancake 101	http://www.edamam.com/ontologies/edamam.owl#recipe_452e9fce1999537b9e5698fda667c75f	https://www.edamam.com/web-img/22c/22c27bdc6b8dc67215c7478cb4e5dc42.jpg	http://smittenkitchen.com/2008/07/blueberry-pancakes-pancake-101/	16	2007.048	266.753739999999993	76.0160999999999945	63.3262
7	Whole Wheat Pancake and Waffle Mix recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_99241f2848aa7b13d40d73a2fece17ea	https://www.edamam.com/web-img/d77/d770f86bae761ddb856245ff4920dbbf	http://www.epicurious.com/recipes/food/views/whole-wheat-pancake-and-waffle-mix-56389938	4	3426.13599999904864	688.784433332883509	40.7109999999999985	124.889099999998137
8	Pancake Bites	http://www.edamam.com/ontologies/edamam.owl#recipe_50e9bc10e9ca1931e1f3640db383e0e8	https://www.edamam.com/web-img/f0e/f0ed4b00777474d6bd7bba85f9dbc7eb.jpg	http://www.bbcgoodfood.com/recipes/1718/pancake-bites	16	4575.4399999999996	746.227999999999952	140.934399999999982	89.3051999999999992
9	Apple Fritter Pancake Puppies	http://www.edamam.com/ontologies/edamam.owl#recipe_161b005b094740ca3c9754592d71ccdf	https://www.edamam.com/web-img/5ca/5ca124505fc1d734fda3e24d85375130.jpg	http://www.kitchendaily.com/recipe/apple-fritter-pancake-puppies	6	1366.61441999999988	143.562747999999999	83.3557120000000111	16.6102179999999997
10	"Instant" Pancake Mix	http://www.edamam.com/ontologies/edamam.owl#recipe_8235bc902aa897dbce54d415bccf64c2	https://www.edamam.com/web-img/600/60019abeaf7e28b2f83c4ef88e4b8d06.jpg	http://www.cookingchanneltv.com/recipes/alton-brown/instant-pancake-mix.html	18	5356.89199999999983	836.183719999999994	162.093340000000012	138.753579999999999
11	Baked Eggs	http://www.edamam.com/ontologies/edamam.owl#recipe_57d41c954296c7332ee57e3f6bc6f99a	https://www.edamam.com/web-img/7c0/7c06d6352abacc41e169a954ebc3740e.jpg	http://leitesculinaria.com/96610/recipes-baked-eggs.html	6	528.031975248973595	2.94344881249648527	38.439033924901949	39.5604877624697835
12	Moonstruck eggs	http://www.edamam.com/ontologies/edamam.owl#recipe_9d74a7986510d0380b3fb47b7b65bf33	https://www.edamam.com/web-img/943/943f98393348d0daf5f239e328c0bb5d.jpg	https://food52.com/recipes/518-moonstruck-eggs	2	786.909999999999968	28.8961999999999968	67.6458999999999975	17.6227000000000018
13	Eggs in Bacon Baskets Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_fb8ffe9e351e02edebe51308b75a2703	https://www.edamam.com/web-img/032/0328892a208744147ea5b03a9d51bcd7.jpg	http://www.seriouseats.com/recipes/2013/04/eggs-in-a-bacon-basket-recipe.html	4	1426	5.34400000000000031	121.620000000000005	71.475200000000001
14	Scrambled Eggs	http://www.edamam.com/ontologies/edamam.owl#recipe_79fb80a8033dc74d016f149f1d08a5a3	https://www.edamam.com/web-img/bb0/bb07590cbccd17721212d5abec88298c.jpg	http://www.marthastewart.com/256901/scrambled-eggs	2	595.073752000000013	2.78978040000000016	53.180511519999996	26.0569432799999987
15	Preserved Lemon Deviled Eggs	http://www.edamam.com/ontologies/edamam.owl#recipe_dda0ee5255a5c1a5eb6b8068e9e44a1a	https://www.edamam.com/web-img/30e/30ec7dcc81cc949e45250e85ca67cc03.jpg	http://notwithoutsalt.com/four-ways-with-deviled-eggs/	4	403.39525000059507	5.31132229180750848	27.0890108333376993	31.9562650000209985
16	Teriyaki Chicken	http://www.edamam.com/ontologies/edamam.owl#recipe_7bf4a371c6884d809682a72808da7dc2	https://www.edamam.com/web-img/262/262b4353ca25074178ead2a07cdf7dc1.jpg	http://www.davidlebovitz.com/2012/12/chicken-teriyaki-recipe-japanese-farm-food/	6	2253.10198130686604	17.7254651413386206	151.563833470205168	161.721750167485965
17	Chicken Vesuvio	http://www.edamam.com/ontologies/edamam.owl#recipe_b79327d05b8e5b838ad6cfd9576b30b6	https://www.edamam.com/web-img/e42/e42f9119813e890af34c259785ae1cfb.jpg	http://www.seriouseats.com/recipes/2011/12/chicken-vesuvio-recipe.html	4	4181.27453870108093	176.188613391387378	274.571129832606687	230.930907952642372
18	Chicken Teriyaki	http://www.edamam.com/ontologies/edamam.owl#recipe_0a3f49a3da07cd8379d4e35f7a1a72fc	https://www.edamam.com/web-img/827/8275cc33e9f0f4314617d5a356900aa7.jpg	http://norecipes.com/blog/2009/07/16/chicken-teriyaki-recipe/	8	1955.85099999817635	60.349512499674816	124.109300000000005	128.725849999997195
19	Chicken Teriyaki	http://www.edamam.com/ontologies/edamam.owl#recipe_888e9fc4a808e9e4ccdb2ac24a6a2f46	https://www.edamam.com/web-img/551/551b906bafd4c45d50033742eaf00c02.jpg	http://www.saveur.com/article/Recipes/Chicken-Teriyaki	2	1020.7600000000001	22.4064000000000014	67.8833600000000104	75.0528000000000048
20	Chicken Satay	http://www.edamam.com/ontologies/edamam.owl#recipe_14ebd7d6d65f761843dba35202de4b37	https://www.edamam.com/web-img/ba6/ba6f66d885e4d62a98055b088a5a85a3.jpg	http://www.bbcgoodfood.com/recipes/3645/	4	1745.44456460192623	19.5920623299527392	61.9903585249641225	267.787870865276943
21	Asparagus	http://www.edamam.com/ontologies/edamam.owl#recipe_c511b0c57b435ee82d5002a4f85ea6af	https://www.edamam.com/web-img/b8e/b8eff68a7194d415c24fdfdec08ac1f4.jpg	http://www.simplyrecipes.com/recipes/asparagus/	4	398.228665799999987	10.5659774100000003	34.6309495080000005	15.2401791620000004
22	Asparagus	http://www.edamam.com/ontologies/edamam.owl#recipe_9c947180df1aa25527f42f3ef67cffe1	https://www.edamam.com/web-img/34e/34e9e72a6465ad07b7c25a60a3e548d6.jpg	http://www.cookingchanneltv.com/recipes/asparagus.html	6	205.524789092200024	42.4560748356900035	1.35701675557200008	20.8969123634580072
23	Blanched Asparagus	http://www.edamam.com/ontologies/edamam.owl#recipe_dd8454cdd34804c81f1b93075ac0d032	https://www.edamam.com/web-img/5b0/5b03e74a5257172a689c73c8d6318f81.jpg	http://www.marthastewart.com/313823/blanched-asparagus	4	90.7184740000000147	17.5993839560000005	0.544310844000000071	9.97903214000000283
24	Fried Asparagus	http://www.edamam.com/ontologies/edamam.owl#recipe_23a6a19663b621e0de3612cb3be09aef	https://www.edamam.com/web-img/337/3372b620f8f2b9c04aba6131bc2496ef.jpg	http://www.saveur.com/article/Recipes/Fried-Asparagus	1	338.238473999999997	17.5993839560000005	28.5443108440000053	9.97903214000000283
25	Roasted Asparagus	http://www.edamam.com/ontologies/edamam.owl#recipe_bc1890426da9c28dccfdccaf87884b21	https://www.edamam.com/web-img/be0/be0bbf75d589052159464bba7b80b592.jpg	http://leitesculinaria.com/79936/recipes-roasted-asparagus.html	6	209.939999999999998	17.5763999999999996	14.0435999999999996	9.96600000000000108
26	Peanut Butter Banana Smoothie Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_59cd2bd25b21a23399cb8fea6f954b42	https://www.edamam.com/web-img/90b/90bdb6373111199cca741fc422ac3c28.jpg	http://www.seriouseats.com/recipes/2012/01/peanut-butter-banana-smoothie.html	1	233.616499999999974	28.7620399999999989	8.85310500000000111	12.5821649999999998
27	Banana-Blueberry Smoothie recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_ae93db912f913e9029ca1aea6d4098c6	https://www.edamam.com/web-img/7e6/7e66222a8e83161bf9edab073b7d4e83	http://www.marthastewart.com/336635/banana-blueberry-smoothie	2	324.533000000000015	66.6870799999999946	1.31120999999999999	16.3948300000000025
28	Banana in golden syrup	http://www.edamam.com/ontologies/edamam.owl#recipe_bd818ac62f10d157503eba108aa37d81	https://www.edamam.com/web-img/11a/11af0bcd0e2bb2fe6e143fef6658a8d9.jpg	https://food52.com/recipes/3333-banana-in-golden-syrup	3	161.784999999999968	42.5542599999999993	0.448809999999999931	1.49562999999999979
29	Banana Cake Or Banana Bread	http://www.edamam.com/ontologies/edamam.owl#recipe_e9c8712e1b095e052f3b3a22215b51fa	https://www.edamam.com/web-img/e1b/e1b969f80f573256873b10da141cb94a.jpg	http://www.davidlebovitz.com/2007/09/banana-bread-or-1/	1	2481.86171281659199	414.423429453964729	74.3770754098932656	48.7132742911888599
30	Toasty Banana Muesli Pots	http://www.edamam.com/ontologies/edamam.owl#recipe_ddc905f1638ceb1ac0eb60852720b2fc	https://www.edamam.com/web-img/266/266bac2e7625db72f3a2350d0029c84e.jpg	http://www.bbcgoodfood.com/recipes/333610/toasty-banana-muesli-pots	4	625	105.476400000000012	23.6228000000000016	16.3164000000000016
31	Artichoke-Olive Crostini	http://www.edamam.com/ontologies/edamam.owl#recipe_5409e71ace99cc38bb8daa34e40dc972	https://www.edamam.com/web-img/c60/c60a206870e6b5cf39941cff8837d599.jpg	http://smittenkitchen.com/2009/04/artichoke-olive-crostini/	4	1630.47213803124987	196.667363206562499	80.1428242703125022	46.6472010928125016
32	Marinated Artichoke Hearts Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_426027aea19d21413e6c01872764aab0	https://www.edamam.com/web-img/382/38272f6a99fd45eeb8aeb486490ccb37.jpg	http://www.seriouseats.com/recipes/2011/04/marinated-artichoke-hearts.html	3	327.48746444861689	47.7216452609167305	9.76067778903339089	13.0583451085334747
33	Tomatoes and Artichoke Hearts	http://www.edamam.com/ontologies/edamam.owl#recipe_223c51c3e4897969edc008530841b925	https://www.edamam.com/web-img/137/137351ff770570963467a64db34651cf.jpg	http://www.marthastewart.com/314681/tomatoes-and-artichoke-hearts	4	364.462743890337549	54.6189269177393797	14.6863176526877499	15.7495030856378762
34	Artichoke, Lemon & Parmesan Pasta	http://www.edamam.com/ontologies/edamam.owl#recipe_4d3256aa5e64c62f9afca06ffd2991b7	https://www.edamam.com/web-img/2fc/2fcdd1b7f002fef83b527e3ea3cc474a.jpg	http://www.bbcgoodfood.com/recipes/9278/	2	807.921291999999994	124.712474999999998	22.8003	32.0338173076923027
35	Artichoke Crostini	http://www.edamam.com/ontologies/edamam.owl#recipe_8d65fd46a897da7cbe626fee60e56c45	https://www.edamam.com/web-img/df2/df24439084d313e77760ac490658c46e.jpg	http://www.saveur.com/article/Recipes/Artichoke-Crostini	4	1479.83264388839552	132.85559356898014	86.0025255063238347	56.7257016471685205
36	Breakfast Pizza	http://www.edamam.com/ontologies/edamam.owl#recipe_3b53c9a0508d5f707a0dfd525f1e4412	https://www.edamam.com/web-img/2cc/2cc78c72b75b0c31f6f2bbe6060acf24.jpg	http://leitesculinaria.com/94320/recipes-breakfast-pizza.html	14	3583.48000000000002	144.883200000000016	256.829599999999971	165.169600000000031
37	Pizza Frizza recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_d7167bbdf03eb4b786684ab6a81d52b4	https://www.edamam.com/web-img/94a/94aeb549b29ac92dced2ac55765f38f9	http://www.marthastewart.com/284463/pizza-frizza	4	655.879392000000053	116.735452800000019	11.0808	20.0640000000000036
38	Pizza Dough	http://www.edamam.com/ontologies/edamam.owl#recipe_1b6dfeaf0988f96b187c7c9bb69a14fa	https://www.edamam.com/web-img/284/2849b3eb3b46aa0e682572d48f86d487.jpg	http://www.lottieanddoof.com/2010/01/pizza-pulp-fiction-jim-lahey/	4	2622.30705384397106	422.245779167062551	70.9389079228591868	73.1129169621458459
39	Pizza	http://www.edamam.com/ontologies/edamam.owl#recipe_2a8e26625b572ca52865c4ac9493c6c8	https://www.edamam.com/web-img/f2b/f2b3fc42f971644191de4b5028d9e218.jpg	http://www.cookingchanneltv.com/recipes/pizza.html	10	2843.61544786466402	358.311694552244887	104.878031830720815	125.845169306548968
40	Lemon Pizza	http://www.edamam.com/ontologies/edamam.owl#recipe_63bca78ecf26e6f4cd742bc29a867b59	https://www.edamam.com/web-img/6fe/6fed47bfde361e1d24e7cb65f56d3990.jpg	https://food52.com/recipes/4707-lemon-pizza	8	1288.35905388697984	186.479774211845012	37.2558726742860031	53.6245041707290113
41	Zucchini Gratin	http://www.edamam.com/ontologies/edamam.owl#recipe_91a8371b119bef367158ea5e58ab223c	https://www.edamam.com/web-img/b42/b428d24e782e63ac54f63e6f7e87ba85.jpg	http://norecipes.com/recipe/zucchini-gratin-recip	4	946.805749999999989	27.2216875000000016	78.3924525000000045	39.5390800000000056
42	Pickled Zucchini	http://www.edamam.com/ontologies/edamam.owl#recipe_f450212ed342fd2651c41ee3c54eaa4b	https://www.edamam.com/web-img/edc/edc562bb936e3021b3abe65b9c0cc283.jpg	http://leitesculinaria.com/94946/recipes-pickled-zucchini.html	8	1965.35351450000007	403.480213534999962	10.0409779199999996	32.6693383850000032
43	Zucchini Pickles	http://www.edamam.com/ontologies/edamam.owl#recipe_f01f58baa52b2b48a7bd8fe458e51147	https://www.edamam.com/web-img/2d3/2d3369aed79cc5cfda6d3b2810296d18.jpg	http://www.lottieanddoof.com/2011/08/zucchini-pickles/	4	1019.33070290000012	228.749722707000018	3.79339558400000065	8.11366767700000224
44	Zucchini Latkes	http://www.edamam.com/ontologies/edamam.owl#recipe_87bd2076fb712e529263b7e9fd625782	https://www.edamam.com/web-img/3d8/3d865a3876ee7eeb2cf5c0d35b17b87d.jpg	http://smittenkitchen.com/2006/12/latke-minus-vodka/	48	1830.67112419248224	94.3993208207552925	156.989851433789312	21.2696736132925714
45	Zucchini Pickles	http://www.edamam.com/ontologies/edamam.owl#recipe_f5b6997b386848d6bd856ef5b8af7456	https://www.edamam.com/web-img/291/291df2a1eef97896d32767f77586f7a2.jpg	http://www.101cookbooks.com/archives/quick-pickled-zucchini-recipe.html	1	538.169730087992775	108.847028979769789	2.98123413813333382	12.3870076264833351
46	Broccoli Rabe	http://www.edamam.com/ontologies/edamam.owl#recipe_ed552e2b04fbd836149044ac0e91b3fb	https://www.edamam.com/web-img/88d/88d23618c19c48e5fdc03c561eee5fe9.jpg	http://nymag.com/restaurants/articles/recipes/broccolirabe.htm	8	1067.8160077844002	59.3187520273800075	81.1360709871439951	58.8704342829160083
47	Broccoli	http://www.edamam.com/ontologies/edamam.owl#recipe_2ffb480936f89facb15b00347e74950c	https://www.edamam.com/web-img/2ba/2babdf595faa43af14dd8ee0f886609c.jpg	http://www.goodhousekeeping.com/food-recipes/a9276/steamed-broccoli-garlic-recipes/	16	530.188885000000141	34.3424832500000008	42.2764401000000021	13.5342526499999991
48	Grilled Broccoli Rabe Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_965ec1f27909d56e789023a1e808d21b	https://www.edamam.com/web-img/2cb/2cb89fc96476d657dfcd634b89f069f6.jpg	http://www.seriouseats.com/recipes/2011/09/grilled-broccoli-rabe-recipe.html	4	347.549321400170129	14.9989725450533733	29.5700626130018591	14.6484331290027097
49	Grilled Broccoli	http://www.edamam.com/ontologies/edamam.owl#recipe_32db1cd6d310abff125ece177ba76e8b	https://www.edamam.com/web-img/f4f/f4fe99f7eb0d789f4152a79554be4c21.jpg	https://food52.com/recipes/6823-grilled-broccoli	4	652.120000000000005	80.7424000000000035	31.4992000000000019	34.2911999999999964
50	Parmesan Broccoli	http://www.edamam.com/ontologies/edamam.owl#recipe_7ea56c71388699ce63a0155ab53d8e44	https://www.edamam.com/web-img/b2c/b2cb8de9c8e4ad7bbd2a12d45a577c9a.jpg	http://www.bbcgoodfood.com/recipes/2565/parmesan-broccoli	6	681.25	61.384999999999998	36.5225000000000009	43.4675000000000011
51	Eggplant Pizzettes	http://www.edamam.com/ontologies/edamam.owl#recipe_c75747b8789a0de43ed6de461ad72464	https://www.edamam.com/web-img/c5b/c5b103249c806dc6f2407e58ae39d883.jpg	http://leitesculinaria.com/866/recipes-eggplant-pizzettes.html	4	1782.91267800625019	85.4521601069500036	134.027441541325004	68.4761094143250091
52	Strawberry Milk	http://www.edamam.com/ontologies/edamam.owl#recipe_290727e0c9bc98848a7f0225c80e4314	https://www.edamam.com/web-img/9c3/9c33940a117c378a3dc189ab098a5201.jpg	http://simplyrecipes.com/recipes/strawberry_milk/	2	358.080000000000041	53.8896000000000015	11.9619374999999994	11.8044937499999989
53	Crunchy French Toast	http://www.edamam.com/ontologies/edamam.owl#recipe_82c599e4d1d8584d498087c20d6e1851	https://www.edamam.com/web-img/d0b/d0bff7bb810d2e1e857ccd16bd91fe47.jpg	http://simplyrecipes.com/recipes/crunchy_french_toast/	2	518.794768616913416	64.4735809927170607	17.7515123018347083	25.161307222506835
54	Grilled Eggplant	http://www.edamam.com/ontologies/edamam.owl#recipe_85c5a35917c2fe2b116ae866bfe8df24	https://www.edamam.com/web-img/ed6/ed666347ee6b15747912d8c80bd842ba.jpg	http://www.finecooking.com/recipes/grilled-eggplant.aspx	4	449.872454925000056	21.6036973983600014	41.1613376754599969	3.60061623306000023
55	Milk Liqueur	http://www.edamam.com/ontologies/edamam.owl#recipe_95661be6f77a57b4c85c789a3b737ada	https://www.edamam.com/web-img/417/417cb5d5c104db03142e6cbea430b259.jpg	http://www.seriouseats.com/recipes/2010/08/milk-liqueur-recipe.html	8	3410.60542200000054	462.277490553749999	32.9567138750000055	18.0723599425000003
56	Milk Punch	http://www.edamam.com/ontologies/edamam.owl#recipe_70b4465eaee604e8f23ed1f9df2f37ac	https://www.edamam.com/web-img/b6f/b6faf987cd257636f01b50cf02124278.jpg	http://smittenkitchen.com/2010/12/milk-punch/	6	2004.64000000000033	160.308099999999996	39.6578000000000088	38.4378000000000029
57	Milk Glaze	http://www.edamam.com/ontologies/edamam.owl#recipe_c8891b3a0ce5f02f252dfc19d268bb3c	https://www.edamam.com/web-img/959/959d3798cac588d96f5081c0e9273d3a.jpg	http://www.marthastewart.com/355547/milk-glaze	2	407.300000000000011	101.209999999999994	0.974999999999999978	0.944999999999999951
58	Cereal Milk	http://www.edamam.com/ontologies/edamam.owl#recipe_1536d23f0618847704c4f2514d38cdcb	https://www.edamam.com/web-img/eed/eeda56f2e3352a3d0d09fe0dbb07500f.jpg	http://leitesculinaria.com/81435/recipes-cereal-milk.html	4	937.539999998233156	135.651749999543938	30.0455000000000005	34.6304999999994436
59	Green Velvet Silver Dollar Pancakes recipes	http://www.edamam.com/ontologies/edamam.owl#recipe_eb33efd9076c055034758bddc91a778f	https://www.edamam.com/web-img/701/701356b4fa81da4979ca2c62b25c4e8f	http://www.goodhousekeeping.com/food-recipes/a15607/green-velvet-silver-dollar-pancakes-recipe-ghk0314/	24	1540.75399999999968	201.714840000000009	69.9007599999999769	31.6522000000000006
60	My Father's Eggplant Spread	http://www.edamam.com/ontologies/edamam.owl#recipe_4c6ee298b4c4b0f6503f440a0d4d2ed6	https://www.edamam.com/web-img/d08/d08584c663533b0312cddd4755992c42.jpg	http://www.sevenspoons.net/blog/2007/6/8/the-start-remains-the-same.html	4	319.448615999999959	53.4049499999999995	11.5579000000000001	8.51100000000000101
61	Darlene Dougherty's Coffee Oat-Bran Pancakes	http://www.edamam.com/ontologies/edamam.owl#recipe_76b96ac7638f290dc2d5fbe3145d44f1	https://www.edamam.com/web-img/870/87022aa8f8df1b606118c8864d79c756.jpg	http://www.delish.com/cooking/recipe-ideas/recipes/a28844/darlene-doughertys-oat-bran-pancakes/	6	586.039999999999964	125.900000000000006	2.64480000000000004	21.428799999999999
62	Hungry Girl-nola	http://www.edamam.com/ontologies/edamam.owl#recipe_44a70ddf0c69143922a8e3e8793ed8a3	https://www.edamam.com/web-img/bfc/bfcc14d2b5a7b36bb1f62aaf7450b104.jpg	http://www.cookingchanneltv.com/recipes/lisa-lillien/hungry-girl-nola.html	1	247.710000000000008	57.5280500000000075	1.78235000000000032	4.10280000000000022
63	Rice Cereal Bars	http://www.edamam.com/ontologies/edamam.owl#recipe_4078f5c04c46b50d6e9a5651e122f672	https://www.edamam.com/web-img/37a/37a0082b7989719393e8c8c8a2aca100.jpg	http://notwithoutsalt.com/pieces-of-heaven-mixed-with-cereal/	6	1646.450835375	305.947703006249981	47.0574704624999995	10.8777141625000002
64	Cinnnamon Cereal Swirl Bread	http://www.edamam.com/ontologies/edamam.owl#recipe_cb73c9e29b1be6e8253d1455c8729720	https://www.edamam.com/web-img/40d/40d1c61d615ddaf7d0c395969c850c6e.JPG	http://www.seriouseats.com/recipes/2012/03/cinnnamon-cereal-swirl-bread-recipe.html	8	1756.97300791406246	273.894937628828131	52.186413443593743	43.0877297917187505
65	Cranberry-Oat Cereal Bars	http://www.edamam.com/ontologies/edamam.owl#recipe_a82cdbb926af3e1b8ce980030b2510b4	https://www.edamam.com/web-img/6bc/6bc2f06c23bd5c3005bc429307abfa1b.jpg	http://www.marthastewart.com/313888/cranberry-oat-cereal-bars	10	2775.4507846567335	576.697207405205063	60.9797118879792848	38.6975956273315447
66	Cereal Milk Ice Cream	http://www.edamam.com/ontologies/edamam.owl#recipe_c3e62e8bdbaf2d10e45e1b93852dd5f0	https://www.edamam.com/web-img/103/1031707125b2172b225f18d59ff6cca3.jpg	https://food52.com/recipes/31159-cereal-milk-ice-cream	14	4006.17000000000007	585.75574666666671	169.29473333333334	63.586273333333331
67	Oatmeal Pancakes	http://www.edamam.com/ontologies/edamam.owl#recipe_8c5723346e509dd611909f682c5fb125	https://www.edamam.com/web-img/662/662a567350d58ba234a2758e2364145f.jpg	http://smittenkitchen.com/2010/05/oatmeal-pancakes/	4	1638.44799999999987	222.119219999999984	62.899160000000002	49.6149000000000058
68	Chai Oatmeal	http://www.edamam.com/ontologies/edamam.owl#recipe_62f760c6ecd9c643a5ad6cbee7d5fc56	https://www.edamam.com/web-img/665/665159cadeae2d521278aa5403324f5c.jpg	https://food52.com/recipes/9321-chai-oatmeal	1	372.821500000000015	53.3213650000000072	11.6621600000000001	15.2864199999999997
69	Irish Oatmeal Biscuits	http://www.edamam.com/ontologies/edamam.owl#recipe_571504e5eecf8fa6da87d1e581393be8	https://www.edamam.com/web-img/b27/b271e4f77c837a9046837e6502568880.jpg	http://www.marthastewart.com/259912/irish-oatmeal-biscuits	8	1941.01350000000002	174.656395000000003	131.645240000000001	20.6113300000000024
70	Simple Spring Salad Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_8a0784ba05fc62b1aabe462f277425a2	https://www.edamam.com/web-img/06b/06b84307cd559b1c610c560109df8ee0.jpg	http://www.101cookbooks.com/archives/a-simple-spring-salad-recipe.html	4	834.555000000000064	53.1011500000000041	68.8098000000000098	14.5763000000000016
71	Mixed Greens Salad	http://www.edamam.com/ontologies/edamam.owl#recipe_3173e6b270d881fecc115c2721aa8741	https://www.edamam.com/web-img/893/893b3132c9db111710d5e823a1a84dd7.jpg	https://www.chowhound.com/recipes/mixed-greens-salad-31352	4	328.925000000000011	9.18550000000000111	32.1315000000000026	6.00600000000000023
72	Scrummy Warm Arugula Salad	http://www.edamam.com/ontologies/edamam.owl#recipe_c5a89acb06b3f1cb35da47c3a070bb43	https://www.edamam.com/web-img/534/534bd1b69cf90ac729f452c3f74e5c93.jpg	http://leitesculinaria.com/37806/recipes-warm-arugula-salad.html	4	1521.89549999999986	44.6100450000000066	124.380715000000009	57.0127500000000111
73	Smoked Turkey	http://www.edamam.com/ontologies/edamam.owl#recipe_414951caa44422f528ad37a35cf0812e	https://www.edamam.com/web-img/6e5/6e5cdc3ba168fd8952cc776552afbbe9.jpg	http://leitesculinaria.com/91246/recipes-smoked-turkey.html	22	7187.4980000000005	15.3277000000000019	282.56268	1083.86662000000001
74	Basic Turkey Gravy Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_e450c377860e3362e33711117b1ed3e0	https://www.edamam.com/web-img/f0c/f0c28799f982d3feb7cda573a6ae217f.jpg	http://www.seriouseats.com/recipes/2013/11/basic-turkey-gravy-thanksgiving-recipe.html	6	874.138939999999934	59.7795129999999943	57.9586693999999909	28.2291616000000012
75	Turkey Hasselback	http://www.edamam.com/ontologies/edamam.owl#recipe_b4f6632c7dc04a89fc627a5244665bee	https://www.edamam.com/web-img/ba1/ba1bbbc2c7dd1837437f9417090c2938.jpg	https://food52.com/recipes/14719-turkey-hasselback	10	2833.65000000000009	50.8999999999999986	125.335000000000008	351.857499999999959
76	Tomato & Dinner Roll Panzanella	http://www.edamam.com/ontologies/edamam.owl#recipe_e3e22590e314df786f3d7489c6806073	https://www.edamam.com/web-img/1c0/1c083fd6f4412a511d7f30e618ae5b5a.jpg	http://www.biggirlssmallkitchen.com/2010/08/recipe-flash-tomato-dinner-roll.html	1	465.796874998630642	56.8215767187287852	23.3118699998896233	11.2503335936762934
77	Chocolate-Covered Cereal	http://www.edamam.com/ontologies/edamam.owl#recipe_af76b3016c5367117dc4be6c2dd4686d	https://www.edamam.com/web-img/5e6/5e659716a0f9f3bd37e114d837c99118.jpg	http://www.cookstr.com/Cereals/Chocolate-Covered-Cereal	72	2851.24337600000035	452.645524430000023	139.077711000000022	41.0508795400000039
78	Black Bean Confetti Salad	http://www.edamam.com/ontologies/edamam.owl#recipe_9ef878f63b28a75e389c216a2839ed6d	https://www.edamam.com/web-img/cc4/cc4add839ac61f9e6322cd9edb861cfc.jpg	http://smittenkitchen.com/2007/04/tabula-beana/	6	1340.94748131304459	185.623189815772605	45.0899360118749968	57.4823135831255385
79	Dinner Rolls with Chive Butter	http://www.edamam.com/ontologies/edamam.owl#recipe_fde77dd059e1fc6d73a2e3fcd52b1b10	https://www.edamam.com/web-img/04d/04de86a50247de0e7315c23080fc7a8c.jpeg	http://www.foodnetwork.com/recipes/robin-miller/dinner-rolls-with-chive-butter-recipe.html	4	488.18081250046373	58.5072281251181252	22.7009862500060251	13.2002356250191912
80	Dinner Rolls	http://www.edamam.com/ontologies/edamam.owl#recipe_8e36bd12a314018a0568c836abd18e09	https://www.edamam.com/web-img/93e/93e5b83cd6fbd7db7ef87a561696be97.jpg	http://www.marthastewart.com/312832/dinner-rolls	30	4334.87297507812491	670.720811716062485	126.954799354906243	117.769148575874993
81	Egg Salad	http://www.edamam.com/ontologies/edamam.owl#recipe_838ea2646532643b485189c6e65f6345	https://www.edamam.com/web-img/da0/da023ba9d1e2cfef33f1f4093ffbd7f3.jpg	http://notwithoutsalt.com/an-egg-story/	4	680.508314000000041	3.98565530000000035	59.2377336399999948	30.4665774599999999
82	Pierogi with Broccoli	http://www.edamam.com/ontologies/edamam.owl#recipe_57f48e95b620df0fe2e594b0b56f9ed0	https://www.edamam.com/web-img/1da/1da57bbe57658865866392522416907d.jpg	http://www.goodhousekeeping.com/food-recipes/a12674/pierogi-broccoli-121625/	4	2530.66499999999996	270.572274999999991	119.275500000000008	96.1668500000000108
83	Egg Nests	http://www.edamam.com/ontologies/edamam.owl#recipe_468da4d5a0243c5f3f8abde5de6acc00	https://www.edamam.com/web-img/e9d/e9de74b322caae3a4bbb25fde3f1ce4b.jpg	http://www.simplyrecipes.com/recipes/egg_nests/	2	259.270000000000039	0.737999999999999989	18.8507999999999996	20.6388999999999996
84	Biala Kielbasa with Pierogi and Sauerkraut Recipe	http://www.edamam.com/ontologies/edamam.owl#recipe_8ed5b799a45ea0f74b84f61325444d9b	https://www.edamam.com/web-img/f32/f32128f489f0a2ea22e4560b64b9810e.jpg	http://www.seriouseats.com/recipes/2009/05/biala-kielbasa-with-pierogi-and-sauerkraut-recipe-polish-food.html	16	4776.16597279999951	276.838098530000025	327.374713214999986	180.757854218999995
85	Panzanella	http://www.edamam.com/ontologies/edamam.owl#recipe_fc909e78e49012821daa571677773689	https://www.edamam.com/web-img/08e/08e70fa94ad9f315e3066d70f5fd041e.jpg	http://www.bonappetit.com/recipes/2012/08/panzanella	6	1281.3392402922002	65.6990450096900105	111.758650507572	15.3732357354579996
86	Panzanella	http://www.edamam.com/ontologies/edamam.owl#recipe_3df489e4ba71d8b8a747d422dded0fa8	https://www.edamam.com/web-img/12f/12f5174800d52cfd181cb41e3a8ab831.JPG	https://food52.com/recipes/328-panzanella	4	779.170908852393836	78.2792675996584109	37.1421471053973775	35.2263811195116929
87	Pizza Margherita	http://www.edamam.com/ontologies/edamam.owl#recipe_a48ba99bcb994261789daedde6d1c6c1	https://www.edamam.com/web-img/883/88388253faa683ad8228f5ccf14a09b5.jpg	http://www.marthastewart.com/342163/pizza-margherita	6	2437.25044333333381	170.774206236333356	137.634928028333348	125.99572842900001
\.


--
-- Data for Name: recipes_ingredients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.recipes_ingredients (recipe_ingredient_id, recipe_id, ingredient_id, amount) FROM stdin;
1	1	1	245
2	1	2	40
3	1	3	450
4	1	4	43
5	2	5	75
6	2	6	86
7	2	7	1812
8	2	8	30.6796874994813003
9	2	9	49
10	2	10	36
11	3	11	56.7999999999999972
12	3	12	62.5
13	3	13	113.398092500000004
14	3	14	86
15	3	15	84
16	3	16	58
17	4	17	250
18	4	18	283.495231250000018
19	4	19	12
20	4	20	56.5
21	4	21	453.592370000000017
22	4	22	43
23	4	23	6.59152560750000038
24	4	24	3.29576280375000019
25	5	25	0
26	5	26	245
27	5	27	87
28	5	28	28.3999999999999986
29	5	29	11.1999999999999993
30	5	30	73
31	5	31	10.5
32	5	32	258
33	5	33	1.44999999999999996
34	5	34	56.5
35	5	35	2
36	6	36	250
37	6	37	9.19999999999999929
38	6	38	4.59999999999999964
39	6	39	3
40	6	40	37.7999999999999972
41	6	41	100
42	6	42	735
43	6	43	56.7999999999999972
44	6	44	14.1999999999999993
45	7	45	720
46	7	46	66.6666666666666572
47	7	47	27.5999999981334661
48	7	48	13.799999999066733
49	7	49	12
50	7	50	50
51	7	51	245
52	7	52	14
53	7	53	120
54	8	54	140
55	8	55	84
56	8	56	140
57	8	57	12
58	8	58	1856
59	9	59	120
60	9	60	29.5735295620000009
61	9	61	180
62	9	62	1.89999999999999991
63	9	63	42.5999999999999943
64	9	64	2.60000000000000009
65	9	65	6.66999999999999993
66	9	66	5.21347200204319972
67	10	67	750
68	10	68	6.89999999999999947
69	10	69	13.7999999999999989
70	10	70	14.5624999997537934
71	10	71	25.1999999999999993
72	10	72	86
73	10	73	490
74	10	74	56.7999999999999972
75	10	75	240
76	10	76	113
77	10	77	296
78	11	78	4.27209999999675194
79	11	79	300
80	11	80	14.1249999997611901
81	11	81	1.88474999999856729
82	11	82	0.942374999999283647
83	12	83	86
84	12	84	58
85	12	85	71
86	13	86	344
87	13	87	224
88	14	88	200
89	14	89	30
90	14	90	1.5504
91	14	91	0.7752
92	15	92	240
93	15	93	49.6999999999999957
94	15	94	2.20833333344534255
95	15	95	0.75
96	16	96	122.998507577953916
97	16	97	134.727746702655679
98	16	98	15
99	16	99	907.184740000000033
100	17	100	108
101	17	101	15
102	17	102	738
103	17	103	1587.57329500000014
104	17	104	110.25
105	17	105	180
106	17	106	11.3999999999999986
107	17	107	5.99999999989855848
108	17	108	17.3413397699993936
109	17	109	8.67066988499969682
110	18	110	118.5
111	18	111	32
112	18	112	18.1249999996935607
113	18	113	29.8000000000000007
114	18	114	745
115	18	115	42
116	18	116	32
117	18	117	29.099999999508011
118	19	118	14
119	19	119	357.600000000000023
120	19	120	144
121	20	121	107.782197362124549
122	20	122	64
123	20	123	1088
124	21	124	226.5
125	21	125	27
126	21	126	28.3599999999999994
127	21	127	2
128	21	128	1.70316000000000001
129	22	129	5.79110844000000036
130	22	130	907.184740000000033
131	22	131	58
132	22	132	2.89555422000000018
133	23	133	453.592370000000017
134	23	134	2.72155422000000025
135	24	135	453.592370000000017
136	24	136	28
137	25	137	453
138	25	138	13.5
139	25	139	2.79899999999999993
140	26	140	57.8499999999999943
141	26	141	16
142	26	142	247
143	27	143	115.699999999999989
144	27	144	148
145	27	145	245
146	28	146	12.5999999999999996
147	28	147	237
148	28	148	33.5
149	28	149	115.699999999999989
150	29	150	210
151	29	151	4.59999999999999964
152	29	152	2.29999999999999982
153	29	153	3
154	29	154	2.60000000000000009
155	29	155	150
156	29	156	55
157	29	157	33
158	29	158	50
159	29	159	237.754847122333587
160	29	160	152.163102158293498
161	29	161	60
162	30	162	108
163	30	163	136
164	30	164	50
165	30	165	50
166	31	166	3
167	31	167	150
168	31	168	8.59999999999999964
169	31	169	425.242846874999998
170	31	170	54
171	31	171	290
172	32	172	239
173	32	173	6
174	32	174	4.20000000000000018
175	32	175	12
176	32	176	382.718562187500027
177	32	177	2.34375000011887735
178	32	178	8.78916744575161779
179	33	179	13.5
180	33	180	6
181	33	181	248
182	33	182	396.893323750000036
183	33	183	3.98635994250000048
184	34	184	4.78379999999999939
185	34	185	58
186	34	186	25
187	34	187	150
188	34	188	100
189	34	189	18.75
190	35	190	232
191	35	191	8.10520487325000083
192	35	192	3
193	35	193	114
194	35	194	184.271900312500009
195	35	195	6
196	35	196	56.6990462500000021
197	35	197	1.78791283968750037
198	36	198	336
199	36	199	228
200	36	200	112
201	36	201	160
202	36	202	400
203	36	203	224
204	37	204	228
205	37	205	2.73600000000000021
206	37	206	3.1008
207	38	207	513.75
208	38	208	10
209	38	209	5
210	38	210	3.15000000000000036
211	38	211	3
212	38	212	355.5
213	38	213	21.9930529348383565
214	38	214	250
215	38	215	79.3333333333333286
216	38	216	4.85416666691287535
217	38	217	1.60000000000000009
218	38	218	198.446661875000018
219	38	219	180
220	38	220	9
221	38	221	2.42708333345643767
222	38	222	0.450000000000000011
223	39	223	226.796185000000008
224	39	224	14.1747615625000005
225	39	225	12
226	39	226	452
227	39	227	11.3933341193764406
228	39	228	5.69666705968822029
229	39	229	43
230	39	230	59.25
231	39	231	907.184740000000033
232	39	232	4.73333333357341335
233	39	233	2
234	39	234	141.5
235	39	235	32
236	39	236	2
237	39	237	2.25
238	40	238	340.194277499999998
239	40	239	145
240	40	240	1.96377710999999988
241	40	241	8.90245623199999869
242	40	242	56
243	40	243	113.398092500000004
244	41	244	600
245	41	245	6
246	41	246	100
247	41	247	5.20000000000000018
248	41	248	0.275000000000000022
249	41	249	119
250	42	250	1428
251	42	251	300
252	42	252	146
253	42	253	6
254	42	254	9
255	42	255	2
256	42	256	250
257	42	257	2267.96185000000014
258	43	258	453.592370000000017
259	43	259	70
260	43	260	43.6874999992613766
261	43	261	478
262	43	262	200
263	43	263	3
264	43	264	3
265	43	265	3
266	44	266	453.592370000000017
267	44	267	340.194277499999998
268	44	268	113.398092500000004
269	44	269	27.5
270	44	270	50
271	44	271	5.0833333335911659
272	44	272	9
273	44	273	1.44999999999999996
274	44	274	13.6029657973368412
275	45	275	453.592370000000017
276	45	276	110
277	45	277	177.333333333333343
278	45	278	27
279	45	279	2.22500000000000009
280	45	280	33.75
281	45	281	3.14999999999999991
282	45	282	181.834907079160729
283	45	283	181.074091568369255
284	45	284	49.6116654687500045
285	46	285	1814.36948000000007
286	46	286	72
287	46	287	12
288	46	288	11.3902168800000005
289	47	289	453
290	47	290	40.5
291	47	291	9
292	47	292	2
293	47	293	3.02700000000000014
294	48	294	453.592370000000017
295	48	295	12
296	48	296	27
297	48	297	1.80000000000000004
298	48	298	15.2500000007734968
299	49	299	1216
300	49	300	27
301	49	301	2.42708333345643767
302	50	302	900
303	50	303	25
304	50	304	50
305	51	305	18
306	51	306	71.5
307	51	307	48
308	51	308	566.990462500000035
309	51	309	54
310	51	310	226.796185000000008
311	51	311	30
312	51	312	24.75
313	52	313	366
314	52	314	22.3125
315	52	315	42
316	53	316	72.5
317	53	317	28
318	53	318	100
319	53	319	81.3333333333333286
320	53	320	1.30208333339937643
321	53	321	0.100000000000000006
322	53	322	3.85200166666756472
323	54	323	40.5
324	54	324	2.96455422000000013
325	54	325	453.592370000000017
326	55	326	556.000000000000114
327	55	327	488
328	55	328	400
329	55	329	56.6990462500000021
330	55	330	29
331	56	331	1220
332	56	332	333.600000000000023
333	56	333	100
334	56	334	13
335	58	335	77
336	58	336	915
337	58	337	27.4999999995350599
338	58	338	1.21354166672821884
339	60	339	10.2373999999999992
340	60	340	548
341	60	341	150
342	60	342	4
343	60	343	9
344	60	344	33.75
345	60	345	8
346	60	346	4.51649999999999974
347	61	347	474
348	61	348	50
349	61	349	120
350	62	350	20
351	62	351	3.5
352	62	352	3
353	62	353	30
354	62	354	54.5
355	62	355	74
356	63	356	56.7999999999999972
357	63	357	283.495231250000018
358	63	358	84
359	63	359	1.5
360	64	360	9
361	64	361	237
362	64	362	318.932135156250013
363	64	363	8.40000000000000036
364	64	364	56.7999999999999972
365	64	365	7
366	64	366	7.79999999999999982
367	65	367	10.3972999934848485
368	65	368	56.7999999999999972
369	65	369	283.495231250000018
370	65	370	3
371	65	371	300
372	65	372	121.212121212121204
373	66	373	93
374	66	374	610
375	66	375	357
376	66	376	96.6666666666666572
377	66	377	1.5
378	66	378	53.8666666666666671
379	66	379	4.20000000000000018
380	66	380	100
381	66	381	59.25
382	67	382	60
383	67	383	125
384	67	384	9.19999999999999929
385	67	385	3.64062500018465673
386	67	386	42.5999999999999943
387	67	387	305
388	67	388	234
389	67	389	20
390	68	390	244
391	68	391	7.5
392	68	392	1.25
393	68	393	2.60000000000000009
394	68	394	1.19999999999999996
395	68	395	54
396	70	396	196.5
397	70	397	24
398	70	398	35
399	70	399	54
400	70	400	0.75
401	70	401	720
402	70	402	14
403	70	403	40
404	71	404	210
405	71	405	62.5
406	72	406	220
407	72	407	224
408	72	408	6.40000000000000036
409	72	409	12
410	72	410	28.3500000000000014
411	72	411	0.75
412	72	412	40
413	72	413	63.75
414	72	414	57
415	73	415	5002
416	73	416	29.1249999995075868
417	73	417	13.8000000000000007
418	74	418	56.75
419	74	419	31.25
420	74	420	960
421	76	421	42
422	76	422	10
423	76	423	0.574999999999999956
424	76	424	1.5
425	76	425	0.450000000000000011
426	76	426	207
427	76	427	30.6796874994813003
428	77	428	200
429	77	429	453.592370000000017
430	78	430	850.485693749999996
431	78	431	476
432	78	432	55
433	78	433	67
434	78	434	40.5
435	78	435	2.10000000000000009
436	78	436	4.5
437	78	437	3.53125000017910873
438	78	438	0.225000000000000006
439	79	439	28
440	79	440	3
441	79	441	0.143750000184709098
442	79	442	112
443	80	443	59.25
444	80	444	14.1747615625000005
445	80	445	366
446	80	446	113.5
447	80	447	50
448	80	448	13.5
449	80	449	150
450	80	450	781.25
451	81	451	240
452	81	452	10
453	81	453	43.7999999999999972
454	81	454	1.76280000000000014
455	82	455	368
456	82	456	151
457	82	457	453
458	82	458	74.5
459	82	459	28.25
460	83	460	0.606770833364109419
461	83	461	33
462	84	462	907.184740000000033
463	84	463	20.3999999999999986
464	84	464	177.75
465	84	465	453.592370000000017
466	84	466	453.592370000000017
467	84	467	34
468	84	468	120
469	84	469	25
470	85	470	116
471	85	471	369
472	85	472	85.0485693749999996
473	85	473	13.5
474	85	474	24
475	85	475	3.7172914162499997
476	85	476	12
477	87	477	228
478	87	478	52.3333333333333286
479	87	479	27
480	87	480	123
481	87	481	453.592370000000017
482	87	482	18
\.


--
-- Name: recipes_ingredients_recipe_ingredient_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recipes_ingredients_recipe_ingredient_id_seq', 482, true);


--
-- Name: recipes_recipe_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.recipes_recipe_id_seq', 87, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (user_id, fname, lname, email, password) FROM stdin;
1	gosia	gosia	gosia	gosia
2	m	m	m	m
3	b	b	b	b
4	a	a	a	a
5	c	c	c	c
6	d	d	d	d
7	k	k	k	k
8	j	j	j	j
9	g	g	g	g
10	Gosia	Pachocki	gosia@gosia.com	gosia
11	Meret	Merecki	merettm@gmail.com	gosia
12	Szymon	Sidoe	szymecki@szymecki.com	szymong
13	Olenka	LaKrasna	olka@olka.com	olka
14	gosia	gosia	gosia@gosia.com	gosia
15	allergic	allergic	a@all.com	all
16	user@user	user	user@user	user
17	u	u	u@u	u
18	b	b	b@b	b
19	k	k	k@k	k
20	h	h	h@h	h
21	f	l	f@l	fl
22	hu	hu	hu@hu	hu
23	c	c	c@c	c
24	h	h	h@t	h
25	blabla	blabla	bla@la	laa
26	j	j	j@k	j
27	gosia	gosia	gosia@g	gosia
28	K	K	K@K	K
29	bla	bla	bla@bla	bla
30	bl	bl	bl@l	bla
31	1	1	1@1	1
32	2	2	2@2	2
33	4	4	4@4	4
34	user	user	user@user.com	user
35	bla	bla	blabla@bla	bla
36	user	user	user@user.user	user
37	Gosia	Pachocki	gosia_p@gmail.com	gosiap
38	Gosia	Pachocki	gosia_pach@gmail.com	gosia
39	Alice	White	a_white@gmail.com	white
40	Bob	White	bob_white@gmail.com	white
41	Bob	Bob	bob@gmail.com	bob
42	Alice	White	alice@gmail.com	alice
43	Alice	White	alice_white@alice.com	alice
44	Jennifer	Black	j_black@jen.com	black
45	Alice	Black	a_black@gmail.com	black
46	Gosia	Pachocki	g.pachocki@gosia.com	gosia
\.


--
-- Data for Name: users_allergies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_allergies (user_allergy_id, user_id, allergy_id) FROM stdin;
1	1	3
2	3	1
3	3	2
4	4	1
5	4	3
6	4	5
7	5	1
8	6	2
9	7	5
10	7	1
11	8	4
12	8	5
13	13	1
14	13	2
15	14	1
16	15	2
17	15	3
18	15	5
19	15	7
20	15	2
21	15	3
22	15	5
23	15	7
24	16	1
25	16	5
26	18	4
27	20	1
28	20	4
29	20	5
30	23	4
31	24	4
32	24	6
33	25	1
34	25	5
35	27	4
36	27	7
37	29	3
38	31	1
39	34	1
40	34	3
41	35	1
42	35	2
43	35	7
44	36	1
45	36	2
46	37	2
47	37	3
48	37	5
49	38	1
50	38	2
51	39	1
52	39	3
53	40	1
54	40	3
55	42	1
56	42	3
57	43	1
58	43	3
59	45	1
60	45	3
61	46	1
62	46	3
\.


--
-- Name: users_allergies_user_allergy_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_allergies_user_allergy_id_seq', 62, true);


--
-- Data for Name: users_diets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_diets (user_diet_id, user_id, diet_id) FROM stdin;
1	1	1
2	4	6
3	5	6
4	6	6
5	7	1
6	7	2
7	7	4
8	8	1
9	8	4
10	16	3
11	16	7
12	20	1
13	20	9
14	25	4
15	27	2
16	27	4
17	29	4
18	30	4
19	31	1
20	32	2
21	33	4
22	34	4
23	35	2
24	35	4
25	36	2
26	36	4
27	37	2
28	37	4
29	38	2
30	38	4
31	39	2
32	39	4
33	40	2
34	40	4
35	42	2
36	42	4
37	43	2
38	43	4
39	45	2
40	45	4
41	46	2
42	46	4
\.


--
-- Name: users_diets_user_diet_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_diets_user_diet_id_seq', 42, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_user_id_seq', 46, true);


--
-- Name: allergies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergies
    ADD CONSTRAINT allergies_pkey PRIMARY KEY (allergy_id);


--
-- Name: allergies_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergies_recipes
    ADD CONSTRAINT allergies_recipes_pkey PRIMARY KEY (allergy_recipe_id);


--
-- Name: diets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets
    ADD CONSTRAINT diets_pkey PRIMARY KEY (diet_id);


--
-- Name: diets_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets_recipes
    ADD CONSTRAINT diets_recipes_pkey PRIMARY KEY (diet_recipe_id);


--
-- Name: ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (ingredient_id);


--
-- Name: plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_pkey PRIMARY KEY (plan_id);


--
-- Name: plans_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans_recipes
    ADD CONSTRAINT plans_recipes_pkey PRIMARY KEY (recipe_plan_id);


--
-- Name: recipes_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_pkey PRIMARY KEY (recipe_ingredient_id);


--
-- Name: recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (recipe_id);


--
-- Name: users_allergies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_allergies
    ADD CONSTRAINT users_allergies_pkey PRIMARY KEY (user_allergy_id);


--
-- Name: users_diets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_diets
    ADD CONSTRAINT users_diets_pkey PRIMARY KEY (user_diet_id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- Name: allergies_recipes_allergy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergies_recipes
    ADD CONSTRAINT allergies_recipes_allergy_id_fkey FOREIGN KEY (allergy_id) REFERENCES public.allergies(allergy_id);


--
-- Name: allergies_recipes_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.allergies_recipes
    ADD CONSTRAINT allergies_recipes_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id);


--
-- Name: diets_recipes_diet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets_recipes
    ADD CONSTRAINT diets_recipes_diet_id_fkey FOREIGN KEY (diet_id) REFERENCES public.diets(diet_id);


--
-- Name: diets_recipes_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.diets_recipes
    ADD CONSTRAINT diets_recipes_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id);


--
-- Name: plans_recipes_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans_recipes
    ADD CONSTRAINT plans_recipes_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.plans(plan_id);


--
-- Name: plans_recipes_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans_recipes
    ADD CONSTRAINT plans_recipes_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id);


--
-- Name: plans_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.plans
    ADD CONSTRAINT plans_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: recipes_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(ingredient_id);


--
-- Name: recipes_ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.recipes_ingredients
    ADD CONSTRAINT recipes_ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(recipe_id);


--
-- Name: users_allergies_allergy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_allergies
    ADD CONSTRAINT users_allergies_allergy_id_fkey FOREIGN KEY (allergy_id) REFERENCES public.allergies(allergy_id);


--
-- Name: users_allergies_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_allergies
    ADD CONSTRAINT users_allergies_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: users_diets_diet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_diets
    ADD CONSTRAINT users_diets_diet_id_fkey FOREIGN KEY (diet_id) REFERENCES public.diets(diet_id);


--
-- Name: users_diets_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_diets
    ADD CONSTRAINT users_diets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

