# Contenu du repository

  * *src:* source du programme
    * *gedcom.dtd*
    * *gedcom.xsd*
    * *xml2html.xsl*
  * *gedcom_files:* fichiers Gedcom
  * autres dossiers: représentation XML et fichier HTML généré
  * *script.sh:* permet de lancer la vérification de la DTD, du schéma et de lancer la transformation du XML en HTML

**Le programme de conversion d'un fichier Gedcom vers XML n'est pas présent dans le repository**

# Remarques

## Conversion Gedcom vers XML

Le programme n'effectue pas d'optimisation du Gedcom lors de la conversion vers XML. Il re-transcrit le plus fidèlement possible 
le fichier Gedcom en XML.

## Schéma - XSD

La structure du schéma a été principalement axée autour de la ré-utilisabilité des blocs. Quand cela été possible, 
des données ont été "fixées" soit en indicant les différents valeurs possibles soit en utilisant une regex.

## Transformation XML

La représentation choisie a été sous la forme des plusieurs tableaux. Cette forme est visuellement la plus 
"pratique" notamment pour comparer des données entre individu.

Toutes les balises possibles sont affichées qu’elles soient ou non renseignés afin 
de pouvoir comparer plus facilement les données entre tous les individus ou famille.

## Améliorations possibles
  
  * Ajout d'un plugin JS qui permettrait d'effectuer des tris croissants / décroissants sur les différentes colonnes du tableau.

Effectué dans le cadre d'un projet de Master 1 à Paris Diderot - 2014/2015  
[Page du projet](http://www.liafa.jussieu.fr/~carton/Enseignement/XML/Projet/ "Page du projet")