(setq org-publish-project-alist
      '(("orgfiles"
	 :base-directory "~/Sites/swaac/"
	 :base-extension "org"
	 :publishing-directory "~/Sites/swaac-pub/"
	 :publishing-function org-html-publish-to-html
	 :headline-levels 3
	 :section-numbers nil
	 :with-toc t
	 :recursive t
	 )
	("website"
	 :components ("orgfiles")
	 )
	))
