function sizeImage (x as Integer, y as Integer, url as string) as Object
    r = CreateObject("roRegex", "/+", "")
    i = r.Split(url)
    image = i[i.Count() - 1]
    imageUrl = "http://www.wnyc.org/i/"+x+"/"+y+"/c/80/1/"+image
    print  imageUrl
    return imageUrl
End Function  
