;;; setup-theme.el -*- lexical-binding: t; -*-
;; Time-stamp: <2020-02-01 21:47:32 csraghunandan>

;; Copyright (C) 2016-2020 Chakravarthy Raghunandan
;; Author: Chakravarthy Raghunandan <rnraghunandan@gmail.com>

;; function to disable all enabled themes
(defun gh/disable-all-themes ()
  (interactive)
  (mapc #'disable-theme custom-enabled-themes))

;;; Theme hooks
(defvar gh/theme-hooks nil
  "((theme-id . function) ...)")

(defun gh/add-theme-hook (theme-id hook-func)
  (add-to-list 'gh/theme-hooks (cons theme-id hook-func)))

(defun gh/load-theme-advice (f theme-id &optional no-confirm no-enable &rest args)
  "Enhances `load-theme' in two ways:
1. Disables enabled themes for a clean slate.
2. Calls functions registered using `gh/add-theme-hook'."
  (unless no-enable
    (gh/disable-all-themes))
  (prog1
      (apply f theme-id no-confirm no-enable args)
    (unless no-enable
      (pcase (assq theme-id gh/theme-hooks)
        (`(,_ . ,f) (funcall f))))))

(advice-add 'load-theme
            :around
            #'gh/load-theme-advice)

;; a pack of modern color themes for emacs
;; https://github.com/hlissner/emacs-doom-themes/
(use-package doom-themes
  :init
  (defun gh/doom-dark+-theme-hook()
    ;; My modifications for the doom-dark+ theme
    (set-face-attribute 'vertical-border nil :foreground "gray20")

    (with-eval-after-load "golden-ratio-scroll-screen"
      (set-face-attribute 'golden-ratio-scroll-highlight-line-face nil
                          :background 'unspecified :foreground 'unspecified))

    ;; make comments gray instead of green
    (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground "gray30")
    (set-face-attribute 'font-lock-comment-face nil :foreground "gray30")
    (set-face-attribute 'font-lock-doc-face nil :foreground "gray45")

    ;; diff-hl config
    (set-face-attribute 'diff-hl-change nil :background "#339CDB")
    (set-face-attribute 'diff-hl-delete nil :background "#D16969")
    (set-face-attribute 'diff-hl-insert nil :background "#579C4C")

    ;; markdown config
    (set-face-attribute markdown-header-face-1 nil :inherit 'outline-1)
    (set-face-attribute markdown-header-face-2 nil :inherit 'outline-2)
    (set-face-attribute markdown-header-face-3 nil :inherit 'outline-3)
    (set-face-attribute markdown-header-face-4 nil :inherit 'outline-4)
    (set-face-attribute markdown-header-face-5 nil :inherit 'outline-5)
    (set-face-attribute markdown-header-face-6 nil :inherit 'outline-6)

    ;; set face for volatile-highlights to be same as region face
    (set-face-attribute 'vhl/default-face nil :background 'unspecified
                        :inherit 'region)

    ;; don't underline for column-enforce-face, it looks ugly IMO
    (set-face-attribute 'column-enforce-face nil :inherit 'font-lock-warning-face
                        :underline nil :bold t))

  (gh/add-theme-hook 'doom-dark+ #'gh/doom-dark+-theme-hook)

  :config
  (defun my/load-theme (frame)
    (select-frame frame)
    (load-theme 'doom-dark+))
  (if (daemonp)
      (add-hook 'after-make-frame-functions #'my/load-theme)
    (load-theme 'doom-dark+))

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(provide 'setup-theme)
