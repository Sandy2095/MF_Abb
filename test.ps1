$xl=New-Object -ComObject Excel.Application
$wb=$xl.WorkBooks.Open('C:\Users\kumares\Desktop\Servers.xls')
$ws=$wb.WorkSheets.item(1)
$xl.Visible=$false

$ws.Cells.Item(1,1)=1

$wb.SaveAs('C:\Users\kumares\Desktop\Servers.xls')
$xl.Quit()