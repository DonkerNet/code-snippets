/*
 * Makes the security protocols configurable for .NET 4.0 and 4.5.
 * Use this to enable TLS 1.2, which is supported by these .NET versions but disabled by default.
 * Call the method below once in an application.
 * 
 * More info:
 * https://support.microsoft.com/en-us/help/3154519/support-for-tls-system-default-versions-included-in-the--net-framework
 * http://blogs.perficient.com/microsoft/2016/04/tsl-1-2-and-net-support/
 */

private void SetSecurityProtocols()
{ 
    /*
     * Config app setting example:
     * 
     * .NET 4.5: <add key="ServicePointManager.SecurityProtocol" value="Ssl3|Tls|Tls11|Tls12" />
     * .NET 4.0: <add key="ServicePointManager.SecurityProtocol" value="Ssl3|Tls|Tls11|3072" />
     */
     
    string securityProtocols = ConfigurationManager.AppSettings["ServicePointManager.SecurityProtocol"];
 
    if (string.IsNullOrEmpty(securityProtocols))
        return;
 
    SecurityProtocolType protocolTypeCollection = 0;
 
    IEnumerable<string> securityProtocolStrings = securityProtocols
        .Split(new[] {',', '|'}, StringSplitOptions.RemoveEmptyEntries)
        .Select(sp => sp.Trim());
 
    foreach (string protocolTypeString in securityProtocolStrings)
    {
        int protocolTypeInt;
        SecurityProtocolType protocolTypeEnum;
 
        if (int.TryParse(protocolTypeString, out protocolTypeInt))
            protocolTypeCollection |= (SecurityProtocolType)protocolTypeInt;
        else if (Enum.TryParse(protocolTypeString, true, out protocolTypeEnum))
            protocolTypeCollection |= protocolTypeEnum;
    }
 
    ServicePointManager.SecurityProtocol = protocolTypeCollection;
}