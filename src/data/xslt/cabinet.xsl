<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : cabinet.xsl
    Created on : 2 novembre 2022, 20:02
    Author     : Bouvier Léo et Delagrange Alex
    Description:
        Cette transformation xslt a pour but de créer le fichier
        cabinet.html, il représente la page d'une infirmière avec son
        nombre de patients, un récap des actes et un bouton facture
        pour chaque patient.
    
    Fichiers nécessaires : cabinet.xml, facture.js, infirmerPage.css et acte.xml
    
    recommandation : ouvrir le fichier avec un local web serveur à l'adresse
    suivante : http://localhost:8000/html/cabinet.html
    (sinon le js ne fonctionne pas)
    Et les extensions sur navigateurs créé des erreurs.
    
    commande pour local web serveur : py -m http.server sur le repertoire data
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'
                version="1.0">
    <xsl:output method="html"/>

    <xsl:param name="destinedId" select="001"/>
    <xsl:variable name="visitesDuJour">
        <xsl:value-of select="count(//cab:visite[@intervenant = $destinedId])"/>
    </xsl:variable>
    <xsl:variable name="actes" select="document('../xml/actes.xml', /)/act:ngap"/>
    
    <!-- Template général depuis la racine -->
    <xsl:template match="/">
        <html>
            <head>
                <link rel="stylesheet" href="../css/infirmierPage.css"/>
                <title>Cabinet</title>
                <script type="text/javascript" src="../js/facture.js"></script>
                <script type="text/javascript">
                    
                        function openFacture(prenom, nom, actes) {
                            var width  = 500;
                            var height = 300;
                            if(window.innerWidth) {
                                var left = (window.innerWidth-width)/2;
                                var top = (window.innerHeight-height)/2;
                            }
                            else {
                                var left = (document.body.clientWidth-width)/2;
                                var top = (document.body.clientHeight-height)/2;
                            }
                            var factureWindow = window.open('','facture','menubar=yes, scrollbars=yes, top='+top+', left='+left+', width='+width+', height='+height+'');
                            var factureText = afficherFacture(prenom, nom, actes);
                            factureWindow.document.write(factureText);
                        }
                    
                </script>
            </head>
            <body>
                <div id="banniere_image"/>
                <div id="corps">
                    <!-- Appel template page infirmier -->
                    <xsl:apply-templates select="//cab:infirmier[@id = $destinedId]"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- Template pour l'infirmier(e) demandé(e) dans le paramètre destinedId -->
    <xsl:template match="cab:infirmier">
        <div id="entete">
            <xsl:element name="img">
                <xsl:attribute name="src">../photo/<xsl:value-of select="./cab:photo/text()"/></xsl:attribute>
            </xsl:element>
            <h1 id="salutation">
                Bonjour <xsl:value-of select="./cab:prénom/text()"/>,
                <br/>
                Aujourd'hui, vous avez <xsl:value-of select="$visitesDuJour"/> patient(s).
                <br/>
            </h1>
            
        </div>
        
        <br/>
        <!-- Appel template visites -->
        <xsl:apply-templates select="../../cab:patients/cab:patient/cab:visite[@intervenant = $destinedId]">
            <xsl:sort select="./@date" order="ascending"/>
        </xsl:apply-templates>
            
    </xsl:template>
    
    <xsl:template match="cab:visite">
        <div id="visite">
            
        <h2>Visite du <xsl:value-of select="./@date"/></h2>
        <div id="presentation">
        <b>Patient :</b> Mr/Mme <xsl:value-of select="../cab:nom"/>&#160;
        <xsl:value-of select="../cab:prénom"/>.
        <br/>
        <b>Adresse :</b>&#160;
        <xsl:if test = "../cab:adresse/cab:numéro">
            <xsl:value-of select="../cab:adresse/cab:numéro"/>
                        &#160;
        </xsl:if>
             
        <xsl:value-of select="../cab:adresse/cab:rue"/>&#160;
        <xsl:value-of select="../cab:adresse/cab:ville"/>
                        &#160;
        <xsl:value-of select="../cab:adresse/cab:codePostal"/>
            
        <xsl:if test="../cab:adresse/cab:étage">
            ( étage <xsl:value-of select="../cab:adresse/cab:étage"/> )
        </xsl:if>
        </div>
        <br/>
        <br/><p>Soins à appliquer :</p>
        <ul>
            <xsl:apply-templates select="./cab:acte"/>
        </ul>
        <!-- Appel template (liste) acte -->
            
        <br/>
        <br/>
            
        <xsl:variable name="listeActesVisite">
            <xsl:for-each select="cab:acte/@id">
                <xsl:value-of select="."/>|</xsl:for-each>
        </xsl:variable>
        
        <div id="button">
            <xsl:element name="button">
                <xsl:attribute name="onclick">
                    openFacture('<xsl:value-of select="../cab:prénom"/>',
                    '<xsl:value-of select="../cab:nom"/>',
                    '<xsl:value-of select="$listeActesVisite"/>')
                </xsl:attribute>
                <xsl:attribute name="type">button</xsl:attribute>
                Facture
            </xsl:element>
        </div>
        </div>
        <br/>
    </xsl:template>
    
    <xsl:template match="cab:acte">
        <li>
            <xsl:variable name="idActe" select="./@id"/>
            <xsl:value-of select="$actes/act:actes/act:acte[@id = $idActe]/text()"/>
        
            <xsl:variable name="typeActe" select="$actes/act:actes/act:acte[@id = $idActe]/@type"/>
            <br/>
            <b>Type:</b>&#160;
            <xsl:value-of select="$actes/act:types/act:type[@id = $typeActe]/text()"/>
        </li>
    </xsl:template>

</xsl:stylesheet>

