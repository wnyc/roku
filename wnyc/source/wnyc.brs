' *********************************************************
' ** Roku Hello World Example
' *********************************************************
Sub Main()
  port = CreateObject("roMessagePort")
  screen = CreateObject("roParagraphScreen")
  screen.SetMessagePort(port)
  screen.SetTitle("Example")
  screen.AddParagraph("Hello World!")
  screen.Show()
  wait(0, screen.GetMessagePort())
End Sub
