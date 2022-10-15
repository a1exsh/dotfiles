(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(doc-view-resolution 300)
 '(explicit-bash-args '("-c" "EDITOR=emacsclient bash --noediting -i"))
 '(font-use-system-font t)
 '(indent-tabs-mode nil)
 '(markdown-command "markdown_py")
 '(menu-bar-mode nil)
 '(recentf-mode t)
 '(shell-command-with-editor-mode t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(tool-bar-position (quote bottom))
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify))
 '(winner-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "unknown" :family "Mono")))))

(windmove-default-keybindings)

;; Make windmove work in org-mode:
;; (add-hook 'org-shiftup-final-hook 'windmove-up)
;; (add-hook 'org-shiftleft-final-hook 'windmove-left)
;; (add-hook 'org-shiftdown-final-hook 'windmove-down)
;; (add-hook 'org-shiftright-final-hook 'windmove-right)

(put 'upcase-region   'disabled nil)
(put 'downcase-region 'disabled nil)

(require 'package)

;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))

(package-initialize)

(defun ensure-package-installed (&rest packages)
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
 'use-package 'magit 'markdown-mode 'paredit 'xcscope 'yaml-mode 'flx-ido
 'smex 'fill-column-indicator 'cider 'projectile)

(eval-when-compile
  (require 'use-package))

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

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(setq-default fill-column 78)
(use-package fill-column-indicator
  :config
  ;; (setq fci-rule-column 78)
  (add-hook 'prog-mode-hook #'fci-mode))

(use-package cider
  :config
  (setq cider-repl-display-help-banner nil)
  (when (fboundp 'paredit-mode)
    (add-hook 'cider-repl-mode #'paredit-mode)
    (add-hook 'clojure-mode-hook #'paredit-mode)))

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
             (setq fill-column 99)
             (setq indent-tabs-mode f))))

(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt -i")

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1))
