(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))


;; Appearance
(load-theme 'dracula t)
(set-frame-font "Fira Code 9" nil t)


;; Evil Mode
(require 'evil)
  (evil-mode 1)

;; Org Mode Configuration
    ;; Keymaps
    (global-set-key (kbd "C-c l") #'org-store-link)
    (global-set-key (kbd "C-c a") #'org-agenda)
    (global-set-key (kbd "C-c c") #'org-capture)

    (add-hook 'org-capture-mode-hook 'delete-other-windows)

    ;; Org-Capture
    (setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
         "* TODO : %?\n  %a")
        ("j" "Journal" entry (file+datetree "~/org/journal.org")
         "* %?\nEntered on %U\n  %i\n  %a")))

;; ====================================
;; Development Setup
;; ====================================

;; Enable elpy
(elpy-enable)

;; Enable Flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; Enable autopep8
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; ====================================
;; End of Dev Setup
;; ====================================


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files '("~/org/gtd.org"))
 '(package-selected-packages '(org evil-org
			       magit
			       cmake-mode
			       elpy flycheck py-autopep8 blacken 
			       dracula-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
