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

    <xsl:template match="/">
        <ns2:TransportationStatusRequest>
            <cbc:ID><xsl:value-of select="//e:hasStringID"/></cbc:ID>
            <cbc:UBLVersionID>2.1</cbc:UBLVersionID>
            <cbc:CustomizationID>e-Freight</cbc:CustomizationID>
            <cbc:IssueDate><xsl:value-of select="substring-before(//e:issuedAt, 'T')"/></cbc:IssueDate>
            <cbc:IssueTime><xsl:value-of select="substring-after(//e:issuedAt, 'T')"/></cbc:IssueTime>

            <xsl:for-each select="//e:TransportStatusRequest">
                <cbc:TransportationStatusTypeCode>
                    <xsl:value-of select="e:hasStatusInformationCode"/>
                </cbc:TransportationStatusTypeCode>

                <!-- Consignments -->
                <xsl:for-each select="//e:hasConsignment">
                    <cbc:ID>
                        <xsl:value-of select="e:Consignment/e:hasStringID"/>
                    </cbc:ID>
                </xsl:for-each>

                <!-- Periods -->
                <xsl:for-each select="e:hasBeginDateTimeDescription">
                    <cac:StatusPeriod>
                        <cbc:StartDate><xsl:value-of select="substring-before(e:DateTimeInterval, 'T')"/></cbc:StartDate>
                        <cbc:StartTime><xsl:value-of select="substring-after(e:DateTimeInterval, 'T')"/></cbc:StartTime>
                        <cbc:EndDate><xsl:value-of select="substring-before(../e:hasEndDateTimeDescription/e:DateTimeInterval, 'T')"/></cbc:EndDate>
                        <cbc:EndTime><xsl:value-of select="substring-after(../e:hasEndDateTimeDescription/e:DateTimeInterval, 'T')"/></cbc:EndTime>
                    </cac:StatusPeriod>
                </xsl:for-each>
            </xsl:for-each>
        </ns2:TransportationStatusRequest>

    </xsl:template>

</xsl:stylesheet>