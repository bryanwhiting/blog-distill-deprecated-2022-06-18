README


# Build file:
chown -R rstudio _posts 
rmarkdown::render("_posts/2022-00-00-template/README.md")
rmarkdown::render_site()
# open docs/index.html



# build site
rmarkdown::render_site()


# github action (on push)
* identify which files changed on push.
* Build them
* Render site.
* git commit
* git push
