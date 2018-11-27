;; Programs library that may be useful
;; https://emacs.zeef.com/ehartc

;; Start package.el
(require 'package)

;; Add MELPA to the repo list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

;; init package.el
(package-initialize)
(set-face-attribute 'default nil :height 100)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Linum mode
(global-linum-mode t)

;; Config auto-complete
(use-package auto-complete
	     :ensure t
	     :init (progn
		     (ac-config-default)
		     (global-auto-complete-mode t)
		     ))

;; Org-ac, dk what it is, but it works
(use-package org-ac
	     :ensure t
	     :init (progn
		     (require 'org-ac)
		     (org-ac/config-default)
		     ))

;; Web-mode
;; TODO: Auto-complete
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(setq web-mode-enable-current-element-highlight t)

;;(use-package web-mode
;;	     :ensure t
;;	     :config
;;	     (add-to-list 'auto-complete-alist '("\\.html?\\'" . web-mode))
;;	     (add-to-list 'auto-complete-alist '("\\.vue?\\'" . web-mode))
;;	     (setq web-mode-engines-alist
;;		   '(("flask" . "\\.html\\'")))
;;	     (setq web-mode-ac-sources-alist
;;		   '(("css"  . (ac-source-css-property))
;;		     ("vnu"  . (ac-source-words-in-buffer ac-source-abbrev))
;;		     ("html" . (ac-source-words-in-buffer ac-source-abbrev)))))

;; Setup Jedi
(use-package jedi
	     :ensure t
	     :init
	     (add-hook 'python-mode-hook 'jedi:setup)
	     (add-hook 'python-mode-hook 'jedi:ac-setup))

;; Remove startup screen
(setq inhibit-splash-screen t)

;; Stack Overflow On Emacs (sx)
;; https://github.com/vermiculus/sx.el
(use-package sx
  :config
  (bind-keys :prefix "C-c s"
             :prefix-map my-sx-map
             :prefix-docstring "Global keymap for SX."
             ("q" . sx-tab-all-questions)
             ("i" . sx-inbox)
             ("o" . sx-open-link)
             ("u" . sx-tab-unanswered-my-tags)
             ("a" . sx-ask)
             ("s" . sx-search)))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Change font size
(set-face-attribute 'default nil :height 100)

;; JavaScript
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
;; Better imenu
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

;; JavaScript - Refactor
(require 'js2-refactor)
(require 'xref-js2)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)

;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)


(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (misterioso)))
 '(package-selected-packages
   (quote
    (xref-js2 web-mode-edit-element use-package sx pyvenv org-ac js2-refactor jedi highlight-indentation haskell-mode find-file-in-project company))))

;; Change cursor color

(defvar blink-cursor-colors (list  "#92c48f" "#6785c5" "#be369c" "#d9ca65")
  "On each blink the cursor will cycle to the next color in this list.")

(setq blink-cursor-count 0)
(defun blink-cursor-timer-function ()
  "Zarza wrote this cyberpunk variant of timer `blink-cursor-timer'. 
Warning: overwrites original version in `frame.el'.

This one changes the cursor color on each blink. Define colors in `blink-cursor-colors'."
  (when (not (internal-show-cursor-p))
    (when (>= blink-cursor-count (length blink-cursor-colors))
      (setq blink-cursor-count 0))
    (set-cursor-color (nth blink-cursor-count blink-cursor-colors))
    (setq blink-cursor-count (+ 1 blink-cursor-count))
    )
  (internal-show-cursor nil (not (internal-show-cursor-p)))
  )
