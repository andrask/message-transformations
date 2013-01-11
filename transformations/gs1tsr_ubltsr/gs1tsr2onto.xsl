<xsl:stylesheet version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                    xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                    xmlns:e="http://efreight.sti2.at/ontology/crs#"
                    xmlns:ns1="urn:gs1:ecom:transport_status_request:xsd:3"
            >
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:template match="/ns1:transportStatusRequestMessage">
        <rdf:RDF>
        <e:Document>
            <xsl:attribute name="rdf:about">
                <xsl:value-of select="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier" />
            </xsl:attribute>
            <e:hasStringID><xsl:value-of select="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier" /></e:hasStringID>
            <e:issuedAt><xsl:value-of select="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:CreationDateAndTime" /></e:issuedAt>
            <e:hasTypeVersion><xsl:value-of select="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:TypeVersion"/></e:hasTypeVersion>
            <e:hasStandard><xsl:value-of select="sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:Standard"/></e:hasStandard>
            <xsl:for-each select="sh:StandardBusinessDocumentHeader/sh:Sender">
                <e:Sender>
                    <xsl:if test="sh:Identifier != ''">
                        <e:hasStringID><xsl:value-of select="sh:Identifier"/></e:hasStringID>
                    </xsl:if>
                    <e:hasAuthority><xsl:value-of select="sh:Identifier/@Authority" /></e:hasAuthority>
                </e:Sender>
            </xsl:for-each>
            <xsl:for-each select="sh:StandardBusinessDocumentHeader/sh:Receiver">
                <e:Receiver>
                    <xsl:if test="sh:Identifier != ''">
                        <e:hasStringID><xsl:value-of select="sh:Identifier"/></e:hasStringID>
                    </xsl:if>
                    <e:hasAuthority><xsl:value-of select="sh:Identifier/@Authority" /></e:hasAuthority>
                </e:Receiver>
            </xsl:for-each>
        </e:Document>

        <xsl:for-each select="transportStatusRequest">
            <e:TransportStatusRequest>
                <e:hasCreationDateTime><xsl:value-of select="creationDateTime"/></e:hasCreationDateTime>
                <e:hasStatusCode><xsl:value-of select="documentStatusCode"/></e:hasStatusCode>
                <e:hasStringId><xsl:value-of select="transportStatusRequestIdentification/entityIdentification"/></e:hasStringId>
                <e:hasStatusInformationCode><xsl:value-of select="transportStatusInformationCode"/></e:hasStatusInformationCode>

                <e:hasStatusProvider>
                    <e:ProviderParty>
                        <e:hasStringId><xsl:value-of select="transportStatusProvider/gln"/></e:hasStringId>
                    </e:ProviderParty>
                </e:hasStatusProvider>
                <e:hasStatusRequestor>
                    <e:RequestorParty>
                        <e:hasStringId><xsl:value-of select="transportStatusRequestor/gln"/></e:hasStringId>
                    </e:RequestorParty>
                </e:hasStatusRequestor>

                <xsl:for-each select="reportingPeriod">
                    <e:hasBeginDateTimeDescription>
                        <e:DateTimeInterval>
                            <xsl:value-of select="beginDate"/>T<xsl:value-of select="beginTime"/>
                        </e:DateTimeInterval>
                    </e:hasBeginDateTimeDescription>
                    <e:hasEndDateTimeDescription>
                        <e:DateTimeInterval>
                            <xsl:value-of select="endDate"/>T<xsl:value-of select="endTime"/>
                        </e:DateTimeInterval>
                    </e:hasEndDateTimeDescription>
                </xsl:for-each>


                <!-- Only consignment is handled -->
                <xsl:for-each select="transportStatusRequestConsignment">
                    <e:hasConsignment>
                        <e:Consignment>
                            <e:hasStringId><xsl:value-of select="ginc"/></e:hasStringId>
                            <e:hasConsignor>
                                <e:LegalEntity>
                                    <e:hasStringID><xsl:value-of select="consignor/gln"/></e:hasStringID>
                                </e:LegalEntity>
                            </e:hasConsignor>
                            <e:hasConsignee>
                                <e:LegalEntity>
                                    <e:hasStringID><xsl:value-of select="consignee/gln"/></e:hasStringID>
                                </e:LegalEntity>
                            </e:hasConsignee>
                        </e:Consignment>
                    </e:hasConsignment>
                </xsl:for-each>

            </e:TransportStatusRequest>
        </xsl:for-each>

        </rdf:RDF>
    </xsl:template>

</xsl:stylesheet>