/* 
 * The UriParser class treats all URI's as file paths by default, which causes trailing dots to be removed when parsing a string into a URI.
 * This is a known bug present in .NET versions below 4.5 and the following code provides a workaround to this problem for the HTTP and HTTPS scheme.
 * See: https://stackoverflow.com/questions/856885/httpwebrequest-to-url-with-dot-at-the-end
 */

private static void ClearHttpUriCanonicalizeAsFilePathAttribute()
{
    Type uriParserType = typeof(UriParser);
    MethodInfo getSyntax = uriParserType.GetMethod("GetSyntax", BindingFlags.Static | BindingFlags.NonPublic);
    FieldInfo flagsField = uriParserType.GetField("m_Flags", BindingFlags.Instance | BindingFlags.NonPublic);
    if (getSyntax != null && flagsField != null)
    {
        foreach (string scheme in new[] { "http", "https" })
        {
            UriParser parser = (UriParser)getSyntax.Invoke(null, new object[] { scheme });
            if (parser != null)
            {
                int flagsValue = (int)flagsField.GetValue(parser);
                // Clear the CanonicalizeAsFilePath attribute
                if ((flagsValue & 0x1000000) != 0)
                    flagsField.SetValue(parser, flagsValue & ~0x1000000);
            }
        }
    }
}