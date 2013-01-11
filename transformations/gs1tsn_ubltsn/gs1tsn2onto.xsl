<xsl:stylesheet version="1.0"
                    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
                    xmlns:sh="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
                    xmlns:e="http://efreight.sti2.at/ontology/crs#"
                    xmlns:ns1="urn:gs1:ecom:transport_status_notification:xsd:3"
            >
    <xsl:output method="xml" version="1.0" indent="yes"/>

    <xsl:template match="/ns1:transportStatusNotificationMessage">
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
            <e:hasCreationDateTime><xsl:value-of select="sh:StandardBusinessDocumentHeader//sh:CreationDateAndTime"/></e:hasCreationDateTime>
        </e:Document>

        <xsl:for-each select="transportStatusNotification">
            <e:TransportStatus>
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

                <!-- Only consignment is handled -->
                <xsl:for-each select="transportStatusNotificationConsignment">
                    <e:hasConsignmentStatusNotification>
                        <e:ConsignmentStatusNotification>
                            <e:hasConsignment>
                                <e:Consignment>
                                    <e:hasStringID><xsl:value-of select="ginc"/></e:hasStringID>
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
                            <e:hasTransportStatusCondition>
                                <xsl:value-of select="transportStatus/transportStatusConditionCode"/>
                            </e:hasTransportStatusCondition>
                            <xsl:for-each select="transportStatusNotificationTransportMovement">
                                <e:hasTransportMovement>
                                    <e:TransportMovement>
                                        <e:hasSequenceNumber>
                                            <xsl:value-of select="sequenceNumber"/>
                                        </e:hasSequenceNumber>
                                        <e:hasTransportModeTypeCode>
                                            <!-- This should be mapped to modes but documentation for values not found -->
                                            <xsl:value-of select="transportModeTypeCode"/>
                                        </e:hasTransportModeTypeCode>
                                        <xsl:for-each select="actualArrival">
                                            <e:hasTransportEvent>
                                                <e:ArrivalTransportEvent>
                                                    <xsl:call-template name="transportEvent"/>
                                                </e:ArrivalTransportEvent>
                                            </e:hasTransportEvent>
                                        </xsl:for-each>
                                        <xsl:for-each select="actualDeparture">
                                            <e:hasTransportEvent>
                                                <e:DepartureTransportEvent>
                                                    <xsl:call-template name="transportEvent"/>
                                                </e:DepartureTransportEvent>
                                            </e:hasTransportEvent>
                                        </xsl:for-each>
                                    </e:TransportMovement>
                                </e:hasTransportMovement>
                            </xsl:for-each>
                        </e:ConsignmentStatusNotification>
                    </e:hasConsignmentStatusNotification>
                </xsl:for-each>
            </e:TransportStatus>
        </xsl:for-each>

        </rdf:RDF>
    </xsl:template>

    <xsl:template name="transportEvent">
        <xsl:for-each select="logisticLocation">
            <e:hasLocation>
                <xsl:comment>Only city handled here</xsl:comment>
                <xsl:value-of select="address/city"/>
            </e:hasLocation>
        </xsl:for-each>
        <xsl:for-each select="logisticEventDateTime">
            <e:hasTime>
                <xsl:value-of select="date"/>
                <xsl:if test="time">
                    <xsl:value-of select="concat('T',time)"/>
                </xsl:if>
            </e:hasTime>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>