<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:e="http://efreight.sti2.at/ontology/crs#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:transport_status_request="urn:gs1:ecom:transport_status_request:xsd:3"
                xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                xsi:schemaLocation="urn:gs1:ecom:transport_status_request:xsd:3 ../standards/gs1/gs1/ecom/TransportStatusRequest.xsd"

        >

    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:template match="/">
        <transport_status_request:transportStatusRequestMessage>
            <sh:StandardBusinessDocumentHeader>
                <sh:HeaderVersion>1.0</sh:HeaderVersion>
                <sh:Sender>
                    <sh:Identifier Authority="GS1">UNKNOWN</sh:Identifier>
                    <sh:ContactInformation>
                        <sh:Contact>UNKNOWN</sh:Contact>
                    </sh:ContactInformation>
                </sh:Sender>
                <sh:Receiver>
                    <sh:Identifier Authority="GS1">UNKNOWN</sh:Identifier>
                    <sh:ContactInformation>
                        <sh:Contact>UNKNOWN</sh:Contact>
                    </sh:ContactInformation>
                </sh:Receiver>
                <sh:DocumentIdentification>
                    <sh:Standard>GS1</sh:Standard>
                    <sh:TypeVersion>3.0</sh:TypeVersion>
                    <sh:InstanceIdentifier><xsl:value-of select="//e:hasStringID"/></sh:InstanceIdentifier>
                    <sh:Type/>
                    <sh:MultipleType>false</sh:MultipleType>
                    <sh:CreationDateAndTime><xsl:value-of select="//e:issuedAt"/></sh:CreationDateAndTime>
                </sh:DocumentIdentification>
            </sh:StandardBusinessDocumentHeader>

            <xsl:for-each select="//e:TransportStatusRequest">
                <transportStatusRequest>
                    <creationDateTime><xsl:value-of select="e:hasCreationDateTime"/></creationDateTime>
                    <documentStatusCode>COPY</documentStatusCode>
                    <transportStatusRequestIdentification>
                        <entityIdentification><xsl:value-of select="e:hasStringID"/></entityIdentification>
                    </transportStatusRequestIdentification>
                    <transportStatusInformationCode>
                        <xsl:call-template name="transformStatusInformationCodeFromUBL">
                            <xsl:with-param name="value">
                                <xsl:value-of select="e:hasStatusInformationCode"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </transportStatusInformationCode>
                    <transportStatusObjectCode>CONSIGNMENT</transportStatusObjectCode>
                    <transportStatusProvider>
                        <xsl:comment>INFO MISSING ON INPUT</xsl:comment>
                    </transportStatusProvider>
                    <transportStatusRequestor>
                        <xsl:comment>INFO MISSING ON INPUT</xsl:comment>
                    </transportStatusRequestor>
                    <xsl:for-each select="e:hasBeginDateTimeDescription">
                        <reportingPeriod>
                            <beginDate><xsl:value-of select="substring-before(e:DateTimeInterval, 'T')"/></beginDate>
                            <beginTime><xsl:value-of select="substring-after(e:DateTimeInterval, 'T')"/></beginTime>
                            <endDate><xsl:value-of select="substring-before(../e:hasEndDateTimeDescription/e:DateTimeInterval, 'T')"/></endDate>
                            <endTime><xsl:value-of select="substring-after(../e:hasEndDateTimeDescription/e:DateTimeInterval, 'T')"/></endTime>
                        </reportingPeriod>
                    </xsl:for-each>

                    <!-- Consignments -->
                    <xsl:for-each select="e:hasConsignment//e:Consignment">
                        <transportStatusRequestConsignment>
                            <ginc><xsl:value-of select="e:hasStringID"/></ginc>
                            <consignor>
                                <gln>
                                    <xsl:value-of select="e:hasConsignor//e:hasStringID"/>
                                    <xsl:call-template name="checkIdentifierAuthority">
                                        <xsl:with-param name="authority">
                                            <xsl:value-of select="e:hasConsignor//e:hasStringIDSchemeAgencyID"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </gln>
                            </consignor>
                            <consignee>
                                <gln>
                                    <xsl:value-of select="e:hasConsignee//e:hasStringID"/>
                                    <xsl:call-template name="checkIdentifierAuthority">
                                        <xsl:with-param name="authority">
                                            <xsl:value-of select="e:hasConsignee//e:hasStringIDSchemeAgencyID"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </gln>
                            </consignee>
                        </transportStatusRequestConsignment>
                    </xsl:for-each>
                </transportStatusRequest>
            </xsl:for-each>
        </transport_status_request:transportStatusRequestMessage>

    </xsl:template>

    <xsl:template name="transformStatusInformationCodeFromUBL">
        <xsl:param name="value"/>

        <xsl:choose>
            <xsl:when test="$value = 'All deviations'">
                <xsl:value-of select="string('STATUS_AND_MOVEMENT')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="string('STATUS_AND_MOVEMENT')"/>
                <xsl:comment>Mapping of value '<xsl:value-of select="$value"/>' is not possible</xsl:comment>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="checkIdentifierAuthority">
        <xsl:param name="authority"/>

        <xsl:if test="$authority != 'GS1'">
            <xsl:comment>Invalid identifier authority!</xsl:comment>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>