(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(custom-safe-themes
   '("ad7643f68868f802b10bbdb2de64fdf668adb7e5728dfda7097b0db2fe36d832" default))
 '(doc-view-resolution 300)
 '(font-use-system-font t)
 '(global-display-line-numbers-mode t)
 '(global-linum-mode t)
 '(global-num3-mode t)
 '(indent-tabs-mode nil)
 '(ispell-dictionary nil)
 '(markdown-command "markdown_py")
 '(menu-bar-mode nil)
 '(package-selected-packages
   '(flycheck-clj-kondo num3-mode underwater-theme oer-reveal use-package yaml-mode xcscope smex projectile paredit markdown-mode magit flx-ido cider))
 '(recentf-mode t)
 '(shell-command-with-editor-mode t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tool-bar-position 'bottom)
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style 'forward nil (uniquify))
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(num3-face-even ((t (:underline t))))
 '(default ((t (:height 125 :family "Liberation Mono")))))

(server-start)
(setenv "EDITOR" "emacsclient")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

(windmove-default-keybindings)

;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

(put 'upcase-region   'disabled nil)
(put 'downcase-region 'disabled nil)

(require 'package)

;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))

(package-initialize)

;;
;; Problem:  Failed to verify signature archive-contents.sig:
;;
;; Solution: https://bugs-devel.debian.org/cgi-bin/bugreport.cgi?bug=1070664
;;
;; (let ((package-check-signature nil))
;;   (package-refresh-contents)
;;   (package-install 'gnu-elpa-keyring-update))
;;
(defun ensure-package-installed (packages)
  "Assure every package is installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

(ensure-package-installed
 '(cider
   flycheck-clj-kondo
   flx-ido
   magit
   markdown-mode
   num3-mode
   org-re-reveal
   paredit
   projectile
   smex
   underwater-theme
   use-package
   xcscope
   yaml-mode))

(eval-when-compile
  (require 'use-package))

(use-package num3-mode
  :config
  (global-num3-mode t))

(use-package magit)
(use-package markdown-mode)
(use-package paredit)
(use-package xcscope)
(use-package yaml-mode)

(use-package flx-ido
  :config
  (ido-mode t)
  (ido-everywhere t)
  (flx-ido-mode t)
  ;; disable ido faces to see flx highlights:
  (setq ido-enable-flex-matching t)
  (setq ido-use-faces nil))

(use-package smex
  :bind
  (("M-x" . smex)
   ;;("M-X" . smex-major-mode-commands)
   ;;("C-c C-c M-x" . execute-extended-command)
   )
  :config
  (smex-initialize))

(global-set-key (kbd "C-M-;") 'comment-indent)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(setq-default fill-column 78)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
;; (use-package fill-column-indicator
;;   :config
;;   ;; (setq fci-rule-column 78)
;;   (add-hook 'prog-mode-hook #'fci-mode))

(use-package cider
  :config
  (setq cider-repl-display-help-banner nil)
  (when (fboundp 'paredit-mode)
    (add-hook 'cider-repl-mode-hook #'paredit-mode)
    (add-hook 'clojure-mode-hook #'paredit-mode)))

(use-package flycheck-clj-kondo
  :ensure t)

(use-package clojure-mode
  :ensure t
  :config
  (require 'flycheck-clj-kondo)
  (add-hook 'clojure-mode-hook #'flycheck-mode))

(add-hook 'emacs-lisp-mode-hook #'paredit-mode)

(add-hook 'c-mode-hook 'cscope-minor-mode)
(add-hook 'c-mode-hook
	  (function
	   (lambda nil
	     (if (string-match "postgresql" buffer-file-name)
		 (progn
		   (c-set-style "bsd")
		   (setq c-basic-offset 4)
		   (setq tab-width 4)
		   (c-set-offset 'case-label '+)
		   (setq fill-column 79)
		   (setq indent-tabs-mode t))))))

(add-hook 'java-mode-hook
          (function
           (lambda nil
             (setq c-basic-offset 4)
             (setq fill-column 120)
             (setq indent-tabs-mode nil)
             (c-set-offset 'arglist-intro '++)
             (c-set-offset 'arglist-cont-nonempty '++)
             (c-set-offset 'statement-cont '++))))

(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt -i")

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))

(use-package org-re-reveal)
