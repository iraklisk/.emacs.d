;;; setup-mode-line.el -*- lexical-binding: t; -*-
;; Time-stamp: <2020-02-01 21:05:08 csraghunandan>

;; Copyright (C) 2016-2020 Chakravarthy Raghunandan
;; Author: Chakravarthy Raghunandan <rnraghunandan@gmail.com>

;; flash the modeline instead of ringing the bell
;; https://github.com/purcell/mode-line-bell
(use-package mode-line-bell
  :defer 1
  :config (mode-line-bell-mode))

;;  Run M-x all-the-icons-install-fonts to install the fonts needed for
;;  all-the-icons package
(use-package all-the-icons)

;;  A fancy and fast mode-line inspired by minimalism design.
;; https://github.com/seagle0128/doom-modeline/
(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config

  ;; enable size indication mode
  (size-indication-mode)

  ;; enable column number mode
  (column-number-mode)

  ;; Whether display icons in mode-line. Respects `all-the-icons-color-icons'.
  ;; While using the server mode in GUI, should set the value explicitly.
  (setq doom-modeline-icon t))

;; macro to rename mode-name for major-modes
(defmacro rename-modeline (package-name mode new-name)
  `(eval-after-load ,package-name
     '(defadvice ,mode (after rename-modeline activate)
        (setq mode-name ,new-name))))

(rename-modeline "js2-mode" js2-mode "JS2")
(rename-modeline "typescript-mode" typescript-mode "TS")
(rename-modeline "haskell-mode" haskell-mode "𝞴=")

(provide 'setup-mode-line)
