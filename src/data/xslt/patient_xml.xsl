<?xml version="1.0" encoding="UTF-8"?>

<!--
    Document   : patient_xml.xsl
    Created on : 22 novembre 2022, 15:13
    Author     : Léo Bouvier et Alex Delagrange
    Description:
        Ce fichier xsl a pour but de générer un fichier xml pour un seul patient
        à l'image de la balise patient dans cabinet.xml
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                xmlns:cab="http://www.ujf-grenoble.fr/l3miage/medical"
                xmlns:act='http://www.ujf-grenoble.fr/l3miage/actes'
                version="1.0">
    <xsl:output method="xml" indent="yes"/>
    <!-- Paramètre du nom du patient et variable pour le doc 'actes'-->
    <xsl:param name="destinedName">Orouge</xsl:param>
    <xsl:variable name="actes" select="document('../xml/actes.xml', /)/act:ngap"/>
    
    <!-- TODO customize transformation rules 
         syntax recommendation http://www.w3.org/TR/xslt 
    -->
    
    <!-- Template principale du document-->
    <xsl:template match="/">
        
        <!-- On appel la template pour un patient donné-->
        <cab:patient xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'
                    xmlns:cab='http://www.ujf-grenoble.fr/l3miage/medical'
                    xsi:schemaLocation='http://www.ujf-grenoble.fr/l3miage/medical ../xsd/patient.xsd'>
            
            
            <!--
            <xsl:variable name="idDoc" select="//cab:patient[cab:nom/text() = $destinedName]/cab:nom/text()"/>
            <xsl:result-document href="{concat($idDoc,'.xml')}"/>
            -->
            
            <!-- Cette fonction est censé mettre le nom du patient dans le
            fichier output mais elle ne fonctionne pas et produit l'erreur
            suivante : -->
            
            <!-- line 33: Unsupported XSL element 'result-document'. -->
            
            <xsl:apply-templates select="//cab:patient[cab:nom/text() = $destinedName]"/>
        </cab:patient>
        
    </xsl:template>
    
    <!-- On appel le template pour chaque patient (souvent 1 ) -->
    <xsl:template match="cab:patient">
        
        <cab:nom>         
            <xsl:value-of select="cab:nom/text()"/>
        </cab:nom>
        <cab:prénom>
            <xsl:value-of select="cab:prénom/text()"/>
        </cab:prénom>
        <cab:sexe>
            <xsl:value-of select="cab:sexe"/>
        </cab:sexe>
        <cab:naissance>
            <xsl:value-of select="cab:naissance/text()"/>
        </cab:naissance>
        <cab:numéro>
            <xsl:value-of select="cab:numéro/text()"/>
        </cab:numéro>
        <cab:adresse>    
            <cab:rue><xsl:value-of select="cab:adresse/cab:rue/text()"/></cab:rue>
            <cab:ville><xsl:value-of select="cab:adresse/cab:ville/text()"/></cab:ville>
            <cab:codePostal><xsl:value-of select="cab:adresse/cab:codePostal/text()"/></cab:codePostal>
        </cab:adresse>
        
        <xsl:apply-templates select="cab:visite"/> <!-- Template pour chaque visite -->
        
    </xsl:template>
    
    <!-- Ce template est prévu pour chaque visite-->
    <xsl:template match="cab:visite">
        <xsl:variable name="destinedId" select="@intervenant"/>
        
        <xsl:element name="cab:visite">
            <xsl:attribute name="date">
                <xsl:value-of select="@date"/>
            </xsl:attribute>
            
            <!-- On appel le template pour chaque intervenant-->
            <xsl:apply-templates select="../../../cab:infirmiers/cab:infirmier[@id = $destinedId]"/>
            
            
            <!-- On appel le template pour chaque acte-->
            <xsl:apply-templates select="./cab:acte"/>
            
        </xsl:element>
        
    </xsl:template>
    
    <xsl:template match="cab:infirmier">
        <cab:intervenant>
            <cab:nom>
            <xsl:value-of select="cab:nom"/>
            </cab:nom>
            <cab:prénom>
                <xsl:value-of select="cab:prénom"/>
            </cab:prénom>
        </cab:intervenant>
        
    </xsl:template>
    
    <xsl:template match="cab:acte">
        <cab:acte>
            <xsl:variable name="idActe" select="./@id"/>
            <xsl:value-of select="$actes/act:actes/act:acte[@id = $idActe]/text()"/>
        </cab:acte>
        
    </xsl:template>
</xsl:stylesheet>
