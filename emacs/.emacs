(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


;; Appearance
(load-theme 'dracula t)
(set-frame-font "Fira Code Medium 11" nil t)


;; Evil Mode
(require 'evil)
(evil-mode 1)

;; Org Mode Configuration
;; Keymaps
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)

(setq
    org-log-done 'time
    org-agenda-files (list "~/org")
    org-refile-targets '((org-agenda-files :maxlevel . 5))
    org-refile-use-outline-path 'file
)

(add-hook 'org-capture-mode-hook 'delete-other-windows)

;; Org-Capture
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
         "* TODO : %?\n  %t")
	("j" "Journal" entry
	    (file (lambda () 
		(concat
		    "~/org/journal/"
		    (format-time-string "%Y-%m-%d.org")
		))
	    )
	    "* %?\nEntered on %U")
	)
)


;; ====================================
;; Development Setup
;; ====================================

;; ====================================
;; End of Dev Setup
;; ====================================


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(elisp-lint elisp-autofmt markdown-mode dracula-theme org-journal org evil-org magit which-key)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
