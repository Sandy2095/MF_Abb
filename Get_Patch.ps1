 $Computers = Get-Content "C:\Users\kumares\Desktop\computers.txt"
 $Patches = Get-Content "C:\Users\kumares\Desktop\patch.txt"
 write-output "<html>" | add-content C:\Users\kumares\Desktop\output.html
 foreach($Computer in $Computers) 
 { 
 write-output "<div>"$Computer"</div><table border=1>" | add-content C:\Users\kumares\Desktop\output.html
 foreach($patch in $Patches) 
 {
 write-output "<tr><td>"$patch"</td>" | add-content C:\Users\kumares\Desktop\output.html
 if(get-hotfix -id $patch -computername $Computer -ErrorAction Continue)
 {
 write-output "<td>Patch Installed</td>" | add-content C:\Users\kumares\Desktop\output.html
 echo "Patch exists"
 }
 else
 {
 write-output "<td>Patch Not Installed</td></tr>" | add-content C:\Users\kumares\Desktop\output.html
 echo "No Patch"
 }
 }
 write-output "</table><br>" | add-content C:\Users\kumares\Desktop\output.html
 }
 write-output "</html>" | add-content C:\Users\kumares\Desktop\output.html




 #Get-MSHotfix|Where-Object {$_.Installedon -gt ((Get-Date).Adddays(-2))}|Select-Object -Property Computername, KBArticle,InstalledOn, HotFixID, InstalledBy|Format-Table