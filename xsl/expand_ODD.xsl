<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:dhil="https://dhil.lib.sfu.ca"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 7, 2025</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Stylesheet to expand the ODD.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:mode name="valList" on-no-match="text-only-copy"/>
    
    <xsl:param name="verbose" as="xs:string" select="'true'"/>
    <xsl:variable name="base" select="/" as="document-node()"/>
    <xsl:variable name="baseURI" select="document-uri()" as="xs:anyURI"/>
    
    
    <xd:doc>
        <xd:desc>Template for gathering information for a valList from 
        a particular source.</xd:desc>
    </xd:doc>
    <xsl:template match="valList[@source]">
        <xsl:variable name="sources" select="dhil:resolveSource(@source)"/>
        <xsl:copy>
            <xsl:apply-templates select="@* except @source"/>
            <xsl:apply-templates select="$sources" mode="valList"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Just process standard lists of things</xd:desc>
    </xd:doc>
    <xsl:template match="tagsDecl | taxonomy" mode="valList">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template match="category[@xml:id]" mode="valList">
        <xsl:variable name="prefix" select="ancestor::taxonomy[@n][1]/@n" as="xs:string"/>
        <xsl:variable name="id"
            select="(substring-after(@xml:id, ($prefix || '_')), string(@xml:id))[1]"
            as="xs:string"/>
        <valItem ident="{$prefix}:{$id}" mode="add">
            <xsl:apply-templates select="catDesc" mode="#current"/>
        </valItem>
        <xsl:apply-templates select="category" mode="#current"/>
    </xsl:template>
    
    <xsl:template match="catDesc" mode="valList">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="catDesc/term" mode="valList">
     
        <gloss>
            <xsl:apply-templates mode="#current"/>
        </gloss>
    </xsl:template>
    
    <xsl:template match="catDesc/gloss" mode="valList">
        <xsl:message>ALKSJFKLAJSFLKJASF</xsl:message>
        <desc>
            <xsl:apply-templates mode="#current"/>
        </desc>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Each rendition becomes a valItem.</xd:desc>
        <xd:param name="prefix">The prefix to use; this is a 
        parameter just in case there's future instances that require
        different prefixes.</xd:param>
    </xd:doc>
    <xsl:template match="rendition" mode="valList">
        <xsl:param name="prefix" select="parent::tagsDecl/@n" as="xs:string"/>
        <valItem ident="{$prefix}:{@xml:id}" mode="add"/>
    </xsl:template>
    
    
    <xsl:function name="dhil:resolveSource" as="element()*">
        <xsl:param name="source" as="attribute(source)"/>
        <xsl:for-each select="tokenize($source)">
            <xsl:sequence select="dhil:resolve(.)"/>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="dhil:resolve" as="element()" new-each-time="no">
        <xsl:param name="ptr" as="xs:string"/>
        <xsl:sequence select="dhil:debug('Processing ' || $ptr)"/>
        <xsl:variable name="docPtr" select="substring-before($ptr,'#')" as="xs:string?"/>
        <xsl:variable name="doc" select="if ($docPtr) then document(resolve-uri($docPtr, $baseURI)) else $base" as="document-node()"/>
        <xsl:variable name="frag" select="substring-after($ptr,'#')" as="xs:string"/>
        <xsl:variable name="el" select="$doc//*[@xml:id = $frag]" as="element()?"/>
        <xsl:if test="empty($el)">
            <xsl:message terminate="yes">ERROR: No element found for <xsl:value-of select="$ptr"/></xsl:message>
        </xsl:if>
        <xsl:sequence select="$el"/>
    </xsl:function>
    
    <xsl:function name="dhil:debug">
        <xsl:param name="message"/>
        <xsl:if test="$verbose = 'true'">
            <xsl:message>
                <xsl:text>[DEBUG]: </xsl:text>
                <xsl:sequence select="$message"/>
            </xsl:message>
        </xsl:if>
    </xsl:function>
    
    
    
</xsl:stylesheet>