library(Rfacebook)
library(httpuv)
library(devtools)

my_oauth <- fbOAuth(app_id="1339810209425519", app_secret="e5add3a38b1bb1403448b3afe910ff4f")

save(fbOAuth, file="fbOAuth")

load("fbOAuth")

# Get Page Data
getpagedata =getPage(100002667298959, token = my_oauth, n=10)
page <- getPage(page = "kantor staf presiden", token = my_oauth, n=200) 
post <-getPost(post = page$id[7], token = my_oauth, n=200)
post <-getPost(post = "donald trump", token = my_oauth, n=200)
result <- searchFacebook("donald trump", token = my_oauth, n=200)
View(post)

# Search Groups
search_groups <- searchGroup("ahok", token = my_oauth)
View(search_groups)

group_post <-getGroup("1058578774159261", token = my_oauth, n=50, since=NULL, until=NULL)
View(group_post)

#Search Pages
search_pages <- searchPages("ahok", n=100, token = my_oauth)
View(search_pages)


#Get Friends
me <- getUsers("me", token = my_oauth)
friends <- getFriends(my_oauth, simplify = FALSE)
