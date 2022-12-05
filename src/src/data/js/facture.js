var AMIVAL = 3.15;
var AISVAL = 2.65;
var DIVAL = 10.0;

var totalFacture = 0.0;
/*
    Document   : patient_xml.xsl
    Created on : 22 novembre 2022, 15:13
    Authors    : Léo Bouvier et Alex Delagrange
    Description:
        Ce fichier est un javascript permettant d'afficher une facture
        par patient dans le bouton facture de la page cabinet.html
*/
function afficherFacture(prenom, nom, actes)
{
    totalFacture = 0.0;
    var text = "<html>\n";
    text +=
            "    <head>\n\
            <title>Facture</title>\n\
            <link rel='stylesheet' type='text/css' href='../css/style-facture.css'/>\n\
         </head>\n\
         <body>\n";

    
    text += "Facture pour " + prenom + " " + nom + "<br/>";


    // Trouver l'adresse du patient
    var xmlDoc = loadXMLDoc("../xml/cabinet.xml");
    var patients = xmlDoc.getElementsByTagName("cab:patient");
    var i = 0;
    var found = false;

    while ((i < patients.length) && (!found)) {
        var patient = patients[i];
        var localNom = patient.getElementsByTagName("cab:nom")[0].childNodes[0].nodeValue;
        var localPrenom = patient.getElementsByTagName("cab:prénom")[0].childNodes[0].nodeValue;
        if ((nom === localNom) && (prenom === localPrenom)) {
            found = true;
        }
        else {
            i++;
        }
    }

    if (found) {
        text += "Adresse: ";
        // On récupère l'adresse du patient
        var adresse = patient.getElementsByTagName("cab:adresse");

        // adresse = ... à compléter par une expression DOM
        text += adresseToText(adresse);
        text += "<br/>";

        var nSS = patient.getElementsByTagName("cab:numéro")[0].textContent;
        // nss = récupérer le numéro de sécurité sociale grâce à une expression DOM

        text += "Numéro de sécurité sociale: " + nSS + "\n";
    }
    text += "<br/>";



    // Tableau récapitulatif des Actes et de leur tarif
    text += "<table border='1'  bgcolor='#CCCCCC'>";
    text += "<tr>";
    text += "<td> Type </td> <td> Clé </td> <td> Intitulé </td> <td> Coef </td> <td> Tarif </td>";
    text += "</tr>";

    var acteIds = actes.split("|");

    for (var j = 0; j < acteIds.length; j++) {
        if (acteIds[j] != ""){
            text += "<tr>";
            var acteId = acteIds[j];
            text += acteTable(acteId);
            text += "</tr>";
        }
    }
    
     text += "<tr><td colspan='4'>Total</td><td>" + totalFacture + "</td></tr>\n";
     
     text +="</table>";
     
     
    text +=
            "    </body>\n\
    </html>\n";

    return text;
}

// Mise en forme d'un noeud adresse pour affichage en html
function adresseToText(adresse)
{   
    var adresse1 = adresse.item(0);

    var str = adresse1.getElementsByTagName("cab:numéro")[0].textContent+" "+
    adresse1.getElementsByTagName("cab:rue")[0].textContent+" "+
    adresse1.getElementsByTagName("cab:codePostal")[0].textContent+" "+
    adresse1.getElementsByTagName("cab:ville")[0].textContent;
    // Mise en forme de l'adresse du patient
    // A compléter

    return str;
}


function acteTable(acteId)
{
    var str = "";

    var xmlDoc = loadXMLDoc("../xml/actes.xml");
    var actes = xmlDoc.getElementById(acteId);

    // actes = récupérer les actes de xmlDoc
    
    // Clé de l'acte (3 lettres)
    var cle = actes.getAttribute("clé");
    // Coef de l'acte (nombre)
    var coef = actes.getAttribute("coef");
    // Type id pour pouvoir récupérer la chaîne de caractères du type 
    //  dans les sous-éléments de types
    var typeId = actes.getAttribute("type");
    // Chaîne de caractère du type
    var type = xmlDoc.getElementById(typeId).innerHTML;
    // ...
    // Intitulé de l'acte
    var intitule = actes.innerHTML;

    // Tarif = (lettre-clé)xcoefficient (utiliser les constantes 
    // var AMIVAL = 3.15; var AISVAL = 2.65; et var DIVAL = 10.0;)
    // (cf  http://www.infirmiers.com/votre-carriere/ide-liberale/la-cotation-des-actes-ou-comment-utiliser-la-nomenclature.html)
    switch(cle){
        case "AMI":
            var tarif = AMIVAL*coef;
        case "AIS":
            var tarif = AISVAL*coef;
        case "DI":
            var tarif = DIVAL*coef;
    }

    // Trouver l'acte qui correspond
    var i = 0;
    var found = false;
    
// A dé-commenter dès que actes aura le bon type...
//    while ((i < actes.length) && (!found)) {
        // A compléter (cf méthode plus haut)
//        i++;
//    }

    if (found) {
        // A compléter
//        cle = ;
//        coef = ;
//        typeId = ;
//        type = ;
//        intitule = ;
//        tarif = ;
    }

    // A modifier
    str += "<td>" + type + "</td>";
    str += "<td>" + cle + "</td>";
    str += "<td>" + intitule + "</td>";
    str += "<td>" + coef + "</td>";
    str += "<td>" + tarif + "</td>";
    totalFacture += tarif;

    return str;
}



// Fonction qui charge un document XML
function loadXMLDoc(docName)
{
    var xmlhttp;
    if (window.XMLHttpRequest)
    {// code for IE7+, Firefox, Chrome, Opera, Safari
        xmlhttp = new XMLHttpRequest();
    }
    else
    {// code for IE6, IE5
        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
    }

    xmlhttp.open("GET", docName, false);
    xmlhttp.send();
    xmlDoc = xmlhttp.responseXML;

    return xmlDoc;
}
