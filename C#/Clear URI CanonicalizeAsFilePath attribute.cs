/* 
 * Fix for .NET versions below 4.5.
 * Fixes removal of the . at the end of a URL, when parsing a string into a URI using the UriBuilder (also the Uri class).
 * See: https://stackoverflow.com/questions/856885/httpwebrequest-to-url-with-dot-at-the-end
 */

private static void ClearUriCanonicalizeAsFilePathAttribute()
{
    MethodInfo getSyntax = typeof(UriParser).GetMethod("GetSyntax", BindingFlags.Static | BindingFlags.NonPublic);
    FieldInfo flagsField = typeof(UriParser).GetField("m_Flags", BindingFlags.Instance | BindingFlags.NonPublic);
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