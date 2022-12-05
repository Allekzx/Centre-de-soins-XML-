<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patientToHTML.xsl
    Created on : 24 novembre 2022, 11:31
    Authors     : Léo Bouvier Alex Delagrange
    Description:
        Cette transformation xslt utilise le fichier xml produit par
        patient_xml.xsl pour le transformer en page html.
        La page html produite est la page d'un patient qui récapitule :
        - ses coordonnées
        - ses visites
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical" 
                version="1.0">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
    <!-- Template général appliqué sur la balise patient -->
    <xsl:template match="/cab:patient">
        <xsl:param name="dateJour"/>
        
        <html xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical">
            <link rel="stylesheet" href="../css/pagePatient.css"/>
            <head>
                <title><xsl:value-of select="cab:nom"/>&#160;<xsl:value-of select="cab:prénom"/></title>
            </head>
            <body>
                <div id="card">
                    
                    <h1>
                        <xsl:value-of select="cab:nom"/>&#160;<xsl:value-of select="cab:prénom"/>
                    </h1>
                    <br/>
                    
                    <!-- Coordonnées du patient -->
                    <div id="bio">
                        <p>
                            <strong>Sexe : </strong> 
                            <xsl:value-of select="cab:sexe"/>
                            <br/>
                            <br/>
                            <strong>Naissance : </strong> 
                            <xsl:value-of select="cab:naissance/text()"/>
                            <br/>
                            <br/>
                            <strong>Numéro : </strong> 
                            <xsl:value-of select="cab:numéroSS/text()"/>
                            <br/>
                            <br/>
                            <strong>Adresse : </strong> 
                            <br/>
                            <xsl:value-of select="cab:adresse/cab:numéro/text()"/>
                             <xsl:value-of select="cab:adresse/cab:rue"/>
                             <br/> <xsl:value-of select="cab:adresse/cab:codePostal"/>&#160;
                             <xsl:value-of select="cab:adresse/cab:ville"/>
                        </p>
                    </div>    
                    
                    <!-- Tableau des visites -->
                    <xsl:apply-templates select="//cab:visite"/>
                        
                    
                </div>                
            </body>
            
        </html>
    </xsl:template>
    
    <!-- Tableau des visites -->
    <xsl:template match="cab:visite"> <!-- Template pour chaque partie du joueur-->
        <table>
            <caption><h3>Visite du <xsl:value-of select="@date"/></h3></caption>
            <tr>
                <td>Intervenant : </td>
                <td><xsl:value-of select="cab:intervenant/cab:nom/text()"/>&#160;<xsl:value-of select="cab:intervenant/cab:prénom/text()"/></td>
            </tr>
            
            <!-- Lignes des actes -->
            <xsl:apply-templates select="cab:acte"/>
            
        </table>
    </xsl:template>
    
    <!-- Lignes des actes (si plusieurs) -->
    <xsl:template match="cab:acte">
        <tr>
            <td>Acte :</td>
            <td><xsl:value-of select="./text()"/></td>
        </tr>
    </xsl:template>
</xsl:stylesheet>
