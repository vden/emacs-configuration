(require 'magit)

(defvar magit-status-fullscreen-window-configuration-register
  ?b
  "The register to store the current window configuration in when
entering fullscreen magit-status.")

(defvar magit-status-fullscreen-register
  ?g
  "The register to store the fullscreen magit-status
window configuration in.")

(defun magit-status-fullscreen ()
  "Save the current window configuration, run magit-status
and delete other windows, providing a fullscreen git mode.
The previous window configuration is stored in the register
specified by the magit-status-fullscreen-window-configuration-register
variable. The fullscreen magit status configuration is stored
in register specified by the magit-status-register variable."
  (interactive)
  (window-configuration-to-register magit-status-fullscreen-window-configuration-register)
  (magit-status (magit-get-top-dir default-directory))
  (delete-other-windows)
  (window-configuration-to-register magit-status-fullscreen-register))

(define-key magit-status-mode-map (kbd "q")
  '(lambda ()
     (interactive)
     (jump-to-register magit-status-fullscreen-window-configuration-register)))

(provide 'setup-magit)
