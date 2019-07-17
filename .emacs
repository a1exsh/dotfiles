(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(c-basic-offset 4)
 '(column-number-mode t)
 '(font-use-system-font t)
 '(indent-tabs-mode nil)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (org-bullets xcscope projectile scala-mode yaml-mode smex paredit markdown-mode magit flx-ido fill-column-indicator cider)))
 '(scala-indent:step 4)
 '(send-mail-function (quote smtpmail-send-it))
 '(show-paren-mode t)
 '(smtpmail-smtp-server "smtp.googlemail.com")
 '(smtpmail-smtp-service 25)
 '(tool-bar-mode nil)
 '(tool-bar-position (quote bottom))
 '(tooltip-mode nil)
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "unknown" :family "Ubuntu Mono")))))

(windmove-default-keybindings)

;; Make windmove work in org-mode:
(add-hook 'org-shiftup-final-hook 'windmove-up)
(add-hook 'org-shiftleft-final-hook 'windmove-left)
(add-hook 'org-shiftdown-final-hook 'windmove-down)
(add-hook 'org-shiftright-final-hook 'windmove-right)

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

(ensure-package-installed 'yaml-mode
                          'smex
                          'paredit
                          'markdown-mode
                          'magit
                          'flx-ido
                          'fill-column-indicator
                          'org-bullets
                          'cider)

(require 'ido)
(require 'flx-ido)
(ido-mode t)
(ido-everywhere t)
(flx-ido-mode t)
;; disable ido faces to see flx highlights.
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;;(require 'xcscope)

(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(recentf-mode t)

(setq-default fill-column 78)
(require 'fill-column-indicator)
(setq fci-rule-column 80)

(require 'cider)
(setq cider-repl-display-help-banner nil)

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

(put 'downcase-region 'disabled nil)

(add-hook 'clojure-mode-hook
          (function
           (lambda nil
             (put-clojure-indent 'fact 1)
             (put-clojure-indent 'facts 1))))

(add-hook 'clojure-mode-hook #'paredit-mode)
(add-hook 'cider-repl-mode   #'paredit-mode)

(add-hook 'java-mode-hook
          (function
           (lambda nil
             (setq c-basic-offset 2)
             (setq fill-column 99)
             (setq indent-tabs-mode f))))

(add-hook 'java-mode-hook #'paredit-mode)

(add-hook 'prog-mode-hook #'fci-mode)

(setq python-shell-interpreter "ipython3"
      python-shell-interpreter-args "--simple-prompt -i")

(require 'org-bullets)
(put 'upcase-region 'disabled nil)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
