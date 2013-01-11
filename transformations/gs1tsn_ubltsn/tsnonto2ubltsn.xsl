<xsl:stylesheet version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                    xmlns:e="http://efreight.sti2.at/ontology/crs#"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xsi:schemaLocation="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatus-2 ../maindoc/UBL-TransportationStatus-2.1.xsd"
                    xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"
                    xmlns:sac="urn:oasis:names:specification:ubl:schema:xsd:SignatureAggregateComponents-2"
                    xmlns:sbc="urn:oasis:names:specification:ubl:schema:xsd:SignatureBasicComponents-2"
                    xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                    xmlns:ns2="urn:oasis:names:specification:ubl:schema:xsd:TransportationStatus-2"
                    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                    xmlns:xades="http://uri.etsi.org/01903/v1.3.2#"
                    xmlns:ns1="http://uri.etsi.org/01903/v1.4.1#"
                    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                    xmlns:ccts="urn:un:unece:uncefact:documentation:2"
                    xmlns:ns0="urn:oasis:names:specification:ubl:schema:xsd:CommonSignatureComponents-2"
                    xmlns:ccts-cct="urn:un:unece:uncefact:data:specification:CoreComponentTypeSchemaModule:2"
                    xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                    xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"
            >
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:template match="/">
        <ns2:TransportationStatus>
            <cbc:ID><xsl:value-of select="//e:hasStringID"/></cbc:ID>
            <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
            <cbc:CustomizationID>e-Freight</cbc:CustomizationID>
            <cbc:IssueDate><xsl:value-of select="substring-before(//e:issuedAt, 'T')"/></cbc:IssueDate>
            <cbc:IssueTime><xsl:value-of select="substring-after(//e:issuedAt, 'T')"/></cbc:IssueTime>

            <xsl:for-each select="//e:TransportStatus">
                <cbc:TransportationStatusTypeCode>
                    <xsl:value-of select="e:hasStatusInformationCode"/>
                </cbc:TransportationStatusTypeCode>

                <!-- Consignments -->
                <xsl:for-each select="//e:hasConsignmentStatusNotification//e:ConsignmentStatusNotification">
                    <cac:Consignment>
                        <cbc:ID><xsl:value-of select="//e:Consignment/e:hasStringID"/></cbc:ID>
                        <cac:TransportHandlingUnit>
                            <cac:Status>
                                <cbc:ConditionCode>
                                    <xsl:comment>Mapping needed</xsl:comment>
                                    <xsl:value-of select="e:hasTransportStatusCondition"/>
                                </cbc:ConditionCode>
                            </cac:Status>
                        </cac:TransportHandlingUnit>
                    </cac:Consignment>
                    <xsl:for-each select="//e:hasTransportEvent">
                        <xsl:choose>
                            <xsl:when test="e:ArrivalTransportEvent">
                                <cac:TransportEvent>
                                    <cac:Location>
                                        <cac:Address>
                                            <cac:AddressLine>
                                                <cbc:Line><xsl:value-of select="e:ArrivalTransportEvent/e:hasLocation"/></cbc:Line>
                                            </cac:AddressLine>
                                        </cac:Address>
                                    </cac:Location>
                                    <cbc:Description>Arrived</cbc:Description>
                                    <cac:Period>
                                        <cbc:StartDate><xsl:value-of select="substring-before(e:ArrivalTransportEvent/e:hasTime, 'T')"/></cbc:StartDate>
                                        <cbc:StartDate><xsl:value-of select="substring-after(e:ArrivalTransportEvent/e:hasTime, 'T')"/></cbc:StartDate>
                                    </cac:Period>
                                </cac:TransportEvent>
                            </xsl:when>
                            <xsl:when test="e:DepartureTransportEvent">
                                <cac:TransportEvent>
                                    <cac:Location>
                                        <cac:Address>
                                            <cac:AddressLine>
                                                <cbc:Line><xsl:value-of select="e:DepartureTransportEvent/e:hasLocation"/></cbc:Line>
                                            </cac:AddressLine>
                                        </cac:Address>
                                    </cac:Location>
                                    <cbc:Description>Departed</cbc:Description>
                                    <cac:Period>
                                        <cbc:StartDate><xsl:value-of select="substring-before(e:ArrivalTransportEvent/e:hasTime, 'T')"/></cbc:StartDate>
                                        <cbc:StartDate><xsl:value-of select="substring-after(e:ArrivalTransportEvent/e:hasTime, 'T')"/></cbc:StartDate>
                                    </cac:Period>
                                </cac:TransportEvent>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:for-each>

            </xsl:for-each>
        </ns2:TransportationStatus>

    </xsl:template>

</xsl:stylesheet>