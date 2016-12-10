;; Time-stamp: <2016-12-11 01:30:51 csraghunandan>

;; All the highlight stuff config

;; highlight the currently active symbol + move to next/previous occurrence of symbol
;; https://github.com/nschum/highlight-symbol.el
(use-package highlight-symbol
  :diminish highlight-symbol-mode
  :bind (("M-n" . highlight-symbol-next)
	 ("M-p" . highlight-symbol-prev)
	 ("C-c h s" . highlight-symbol))
  :config
  (highlight-symbol-nav-mode))

;; highlight specific operations like undo, yank
;; https://github.com/k-talo/volatile-highlights.el
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config
  (volatile-highlights-mode t))

;; configure hl-line-mode
(use-package hl-line
  :config
  (global-hl-line-mode))

;; best solution for highlighting indent guides so far in emacs
;; https://github.com/DarthFennec/highlight-indent-guides
(use-package highlight-indent-guides
  :config
  (add-hook 'prog-mode-hook (lambda ()
                              (unless (eq major-mode 'web-mode)
                                (highlight-indent-guides-mode))))
  (setq highlight-indent-guides-method 'character
	highlight-indent-guides-character ?∣))

(provide 'setup-highlight)
