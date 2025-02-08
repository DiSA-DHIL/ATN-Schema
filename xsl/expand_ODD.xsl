<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="#all"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    version="3.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Feb 7, 2025</xd:p>
            <xd:p><xd:b>Author:</xd:b> takeda</xd:p>
            <xd:p>Stylesheet to expand the ODD.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xd:doc>
        <xd:desc>Template for gathering information for a valList from 
        a particular source.</xd:desc>
    </xd:doc>
    <xsl:template match="valList[@source]">
        <xsl:variable name="id" select="substring-after(@source,'#')"/>
        <xsl:variable name="list" select="//*[@xml:id = $id]" as="element()"/>
        <xsl:copy>
            <xsl:apply-templates select="@* except @source"/>
            <xsl:apply-templates select="$list" mode="valList"/>
        </xsl:copy>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Just process tagDecls</xd:desc>
    </xd:doc>
    <xsl:template match="tagsDecl" mode="valList">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>Each rendition becomes a valItem.</xd:desc>
        <xd:param name="prefix">The prefix to use; this is a 
        parameter just in case there's future instances that require
        different prefixes.</xd:param>
    </xd:doc>
    <xsl:template match="rendition" mode="valList">
        <xsl:param name="prefix" select="'rnd'"/>
        <valItem ident="{$prefix}:{@xml:id}" mode="add"/>
    </xsl:template>
    
    
    
    
</xsl:stylesheet>