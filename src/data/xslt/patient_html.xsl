<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patientToHTML.xsl
    Created on : 24 novembre 2022, 11:31
    Author     : alexd
    Description:
        Purpose of transformation follows.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical" 
                version="1.0">
    <xsl:output method="html"/>

    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    <xsl:template match="/cab:patient">
        <xsl:param name="dateJour"/> 
        
        <html xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical">
            <link rel="stylesheet" href="../css/pagePatient.css"/>
            <head>
                <title><xsl:value-of select="cab:nom"/>-<xsl:value-of select="cab:prénom"/></title>
            </head>
            <body>
                <div id="card">
                    
                    <h1>
                        <xsl:value-of select="cab:nom"/>-<xsl:value-of select="cab:prénom"/>
                    </h1>
                    <br/>
                    
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
                            <xsl:value-of select="cab:numéro/text()"/>
                            <br/>
                            <br/>
                            <strong>Adresse : </strong> 
                            <br/>
                            <xsl:value-of select="cab:adresse/cab:numéro/text()"/>
                             <xsl:value-of select="cab:adresse/cab:rue"/>
                             <br/> <xsl:value-of select="cab:adresse/cab:codePostal"/>
                             <xsl:value-of select="cab:adresse/cab:rue"/>
                            
                            <xsl:apply-templates select="//cab:visite"/>
                        </p>
                    </div>
                    
                </div>                
            </body>
            
        </html>
    </xsl:template>
    
    <xsl:template match="cab:visite"> <!-- Template pour chaque partie du joueur-->
        <table>
            <caption style="width:350px"><h3>Visite du <xsl:value-of select="@date"/></h3></caption>
            <tr>
                <td>Intervenant : </td>
                <td><xsl:value-of select="cab:intervenant/cab:nom/text()"/>-<xsl:value-of select="cab:intervenant/cab:prénom/text()"/></td>
            </tr>
            <tr>
                <td>Acte :</td>
                <td><xsl:value-of select="cab:acte/text()"/></td>
            </tr>
        </table>
    </xsl:template>
</xsl:stylesheet>
