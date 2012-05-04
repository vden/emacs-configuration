(load-file "~/.emacs.d/epy-init.el")

(require 'setup-magit)
(require 'sane-defaults)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(js2-basic-offset 2)
 '(js2-cleanup-whitespace t)
 '(safe-local-variable-values (quote ((encoding . utf-8))))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(set-frame-font "-*-Ubuntu Mono-normal-normal-normal-*-19-*-*-*-m-0-iso10646-1")
(set-face-background 'region "grey20")
(set-face-background 'secondary-selection "MediumSeaGreen")

(global-hl-line-mode 1)
;; Customize background color of lighlighted line
(set-face-background 'hl-line "#222222")

;; Subtler highlight in magit
(set-face-background 'magit-item-highlight "#121212")
(set-face-foreground 'magit-diff-none "#666666")
(set-face-foreground 'magit-diff-add "#00cc33")

;; No menu bars
(menu-bar-mode -1)

(when window-system
  (setq frame-title-format '(buffer-file-name "%fx" ("%b")))
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (blink-cursor-mode -1))

(add-hook 'before-make-frame-hook 'turn-off-tool-bar)

;; Ditch them scrollbars
(scroll-bar-mode -1)

(require 'sweyla732203)
;; (load-theme 'wheatgrass)
(sweyla732203)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file "~/.places")

;; save a list of open files in ~/.emacs.desktop
;; save the desktop file automatically if it already exists
(setq desktop-save 'if-exists)
(desktop-save-mode 1)

(desktop-load-default)
(global-set-key (kbd "<C-tab>") 'previous-buffer)
(global-set-key (kbd "<C-S-iso-lefttab>") 'next-buffer)

(require 'lambda-mode)
(setq lambda-symbol (string (make-char 'greek-iso8859-7 107)))
(add-hook 'python-mode-hook #'lambda-mode 1)

(defun python-mode-untabify ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
        (untabify (1- (point)) (point-max))))
  nil)

(setq python-basic-indent 4)

(add-hook 'python-mode-hook
        '(lambda ()
           (make-local-variable 'before-save-hook)
           (add-hook 'before-save-hook 'python-mode-untabify)))

(add-hook 'js2-mode-hook
        '(lambda ()
           (make-local-variable 'before-save-hook)
           (add-hook 'before-save-hook 'python-mode-untabify)))

(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;; Line movement
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines 1))
    (next-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (next-line)
      (transpose-lines -1))
    (move-to-column col)))

(global-set-key (kbd "<C-S-down>") 'move-line-down)
(global-set-key (kbd "<C-S-up>") 'move-line-up)

;; Smart copy region
(defun copy-to-end-of-line ()
  (interactive)
  (kill-ring-save (point)
                  (line-end-position))
  (message "Copied to end of line"))

(defun copy-whole-lines (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(defun copy-line (arg)
  "Copy to end of line, or as many lines as prefix argument"
  (interactive "P")
  (if (null arg)
      (copy-to-end-of-line)
    (copy-whole-lines (prefix-numeric-value arg))))

(defun save-region-or-current-line (arg)
  (interactive "P")
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (copy-line arg)))

(global-set-key (kbd "M-w") 'save-region-or-current-line)
(global-set-key (kbd "M-W") '(lambda () (interactive) (save-region-or-current-line 1)))

(defun recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)

(global-set-key (kbd "C-z") 'undo)

(global-set-key (kbd "C-x m") 'magit-status-fullscreen)

(add-to-list 'load-path "~/.emacs.d/nyan-mode")
(require 'nyan-mode)
(nyan-mode)
