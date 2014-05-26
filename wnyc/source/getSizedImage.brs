function getSizedImageUrl (x as String, y as String, url as string) as Object
    r = CreateObject("roRegex", "www.wnyc.org/i/(\d+\/(d+)/", "")
    imageUrl = r.Replace(url, "x/y")
    'image = i[i.Count() - 1]
    print imageUrl
    return imageUrl
End Function  
