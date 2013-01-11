<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                xmlns:e="http://efreight.sti2.at/ontology/crs#"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatusRequest-2 ../maindoc/UBL-TransportationStatusRequest-2.1.xsd"
                xmlns:ns2="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatusRequest-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
        >
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:template match="ns2:TransportationStatusRequest">
        <rdf:RDF>
            <e:Document>
                <xsl:attribute name="rdf:about">
                    <xsl:value-of select="cbc:ID" />
                </xsl:attribute>
                <e:hasStringID><xsl:value-of select="cbc:ID" /></e:hasStringID>
                <e:issuedAt><xsl:value-of select="cbc:IssueDate"/>T<xsl:value-of select="cbc:IssueTime"/></e:issuedAt>
            </e:Document>

            <e:TransportStatusRequest>
                <e:hasCreationDateTime><xsl:value-of select="cbc:IssueDate"/>T<xsl:value-of select="cbc:IssueTime"/></e:hasCreationDateTime>
                <e:hasStringID><xsl:value-of select="cbc:ID" /></e:hasStringID>
                <e:hasStatusInformationCode><xsl:value-of select="cbc:TransportationStatusTypeCode"/></e:hasStatusInformationCode>

                <xsl:for-each select="cac:StatusPeriod">
                    <e:hasBeginDateTimeDescription>
                        <e:DateTimeInterval>
                            <xsl:value-of select="cbc:StartDate"/>T<xsl:value-of select="cbc:StartTime"/>
                        </e:DateTimeInterval>
                    </e:hasBeginDateTimeDescription>
                    <e:hasEndDateTimeDescription>
                        <e:DateTimeInterval>
                            <xsl:value-of select="cbc:EndDate"/>T<xsl:value-of select="cbc:EndTime"/>
                        </e:DateTimeInterval>
                    </e:hasEndDateTimeDescription>
                </xsl:for-each>

                <xsl:for-each select="cac:StatusLocation">
                    <e:hasLocation>
                        <e:Location>
                            <e:hasStringID>
                                <xsl:value-of select="cbc:ID"/>
                            </e:hasStringID>
                            <e:hasPostbox>
                                <xsl:value-of select="//cbc:Postbox"/>
                            </e:hasPostbox>
                            <e:hasCountryCode>
                                <xsl:value-of select="//cbc:Country/cbc:IdentificationCode"/>
                            </e:hasCountryCode>
                        </e:Location>
                    </e:hasLocation>
                </xsl:for-each>

                <!-- Only consignment is processed -->

                <xsl:for-each select="cac:Consignment">
                    <e:hasConsignment>
                        <e:Consignment>
                            <e:hasStringID><xsl:value-of select="cbc:ID"/></e:hasStringID>
                            <e:hasConsignor>
                                <e:LegalEntity>
                                    <e:hasStringID><xsl:value-of select="cac:ConsignorParty/cac:PartyIdentification/cbc:ID"/></e:hasStringID>
                                    <e:hasStringIDSchemeAgencyID><xsl:value-of select="cac:ConsignorParty/cac:PartyIdentification/cbc:ID/@schemeAgencyID"/></e:hasStringIDSchemeAgencyID>
                                </e:LegalEntity>
                            </e:hasConsignor>
                            <e:hasConsignee>
                                <e:LegalEntity>
                                    <e:hasStringID><xsl:value-of select="cac:ConsigneeParty/cac:PartyIdentification/cbc:ID"/></e:hasStringID>
                                    <e:hasStringIDSchemeAgencyID><xsl:value-of select="cac:ConsigneeParty/cac:PartyIdentification/cbc:ID/@schemeAgencyID"/></e:hasStringIDSchemeAgencyID>
                                </e:LegalEntity>
                            </e:hasConsignee>
                        </e:Consignment>
                    </e:hasConsignment>
                </xsl:for-each>


            </e:TransportStatusRequest>

        </rdf:RDF>
    </xsl:template>

</xsl:stylesheet>