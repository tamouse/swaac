(setq org-publish-project-alist
      '(("orgfiles"
	 :base-directory "~/Projects/Sites/swaac/"
	 :base-extension "org"
	 :publishing-directory "~/Projects/Sites/swaac-pub/"
	 :publishing-function org-html-publish-to-html
	 :headline-levels 3
	 :section-numbers nil
	 :with-toc t
	 :recursive t
	 :html-head "<link rel=\"stylesheet\" href=\"/others/style.css\" type=\"text/css\" />"
	 :html-preamble t
	 :auto-sitemap t
	 :sitemap-ignore-case t
	 )
	("others"
	 :base-directory "~/Sites/swaac/others/"
	 :base-extension "css"
	 :publishing-directory "~/Sites/swaac-pub/others/"
	 :publishing-function org-publish-attachment
	 )
	("website"
	 :components ("orgfiles" "others")
	 )
	))
