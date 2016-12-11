;; Time-stamp: <2016-12-11 13:45:34 csraghunandan>

;; web-mode
;; http://web-mode.org/ , https://github.com/fxbois/web-mode
(use-package web-mode
  :mode (("\\.html$" . web-mode)
	 ("\\.djhtml$" . web-mode))
  :bind (("C-c o b" . browse-url-of-file)
         ("C-c [" . emmet-prev-edit-point)
         ("C-c ]" . emmet-next-edit-point))
  :config
  ;; highlight matching tag
  (setq web-mode-enable-current-element-highlight t)

  (defun my-web-mode-hook ()
    "Hook for `web-mode'."
    (set (make-local-variable 'company-backends)
         '((company-tern company-css company-web-html company-files))))
  (add-hook 'web-mode-hook 'my-web-mode-hook)

  ;; Enable JavaScript completion between <script>...</script> etc.
  (defadvice company-tern (before web-mode-set-up-ac-sources activate)
    "Set `tern-mode' based on current language before running company-tern."
    (message "advice")
    (if (equal major-mode 'web-mode)
	(let ((web-mode-cur-language
	       (web-mode-language-at-pos)))
	  (if (or (string= web-mode-cur-language "javascript")
		  (string= web-mode-cur-language "jsx"))
	      (unless tern-mode (tern-mode))
	    (if tern-mode (tern-mode -1))))))
  (add-hook 'web-mode-hook 'company-mode)

  ;; to get completion for twitter bootstrap
  (use-package ac-html-bootstrap :defer t)

  ;; to get completion for HTML stuff
  ;; https://github.com/osv/company-web
  (use-package company-web)

  ;; snippets for HTML
  ;; https://github.com/smihica/emmet-mode
  (use-package emmet-mode
    :init (setq emmet-move-cursor-between-quotes t) ;; default nil
    :diminish (emmet-mode . " 𝛆"))
  ;; start emmet mode after web-mode launches
  (add-hook 'web-mode-hook 'emmet-mode)

  ;; colorize colors in buffers
  (setq web-mode-enable-css-colorization t)

  ;; highlight the current column
  (setq web-mode-enable-current-column-highlight t)

  ;; format HTML and other web related buffers on save
  (when (executable-find "js-beautify")
    (add-hook 'web-mode-hook
              (lambda ()
                (add-hook 'before-save-hook
                          (lambda ()
                            (time-stamp)
                            (web-beautify-html-buffer)
                            (force-backup-of-buffer)) nil t)))))

;; impatient mode - Live refresh of web pages
;; https://github.com/skeeto/impatient-mode
(use-package impatient-mode
  :diminish (impatient-mode . " 𝖎")
  :commands (impatient-mode))

;; configure CSS mode company backends
(use-package css-mode
  :config
  (defun my-css-mode-hook ()
    (set (make-local-variable 'company-backends)
         '((company-css company-dabbrev-code company-files))))
  (add-hook 'css-mode-hook 'my-css-mode-hook)
  ;; fontify colors with `rainbow-mode'
  (add-hook 'css-mode-hook 'rainbow-mode)
  (add-hook 'css-mode-hook 'company-mode)
  (add-hook 'css-mode-hook 'flycheck-mode)

  ;; format CSS buffers on save
  (when (executable-find "js-beautify")
    (add-hook 'css-mode-hook
              (lambda ()
                (add-hook 'before-save-hook
                          (lambda ()
                            (time-stamp)
                            (web-beautify-css-buffer)
                            (force-backup-of-buffer)) nil t)))))

(provide 'setup-web-mode)
