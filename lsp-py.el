;;; lsp-py.el --- LSP client implemenation for Python-LSP-Server -*- lexical-binding: t; -*-

;; Copyright (C) 2021-  Anselm Coogan

;; Author: Anselm Coogan <anselm.coogan@icloud.com>
;; Maintainer: Anselm Coogan
;; Version: 0.0.1
;; Package-Requires: ((emacs "25.1") (lsp-mode "6.0"))
;; Homepage: http://github.com/AnselmC/lsp-py
;; Keywords: language-server-protocol, lsp, python, emacs

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A client for the python-lsp-server (see https://github.com/python-lsp/python-lsp-server) to be used with lsp-mode.

;;; Code:
(require 'lsp-mode)

(lsp-register-client
 (make-lsp-client :new-connection (lsp-stdio-connection "pylsp")
                  :activation-fn (lsp-activate-on "python")
                  :server-id 'lsp-py))

(provide 'lsp-py)
;;; lsp-py.el ends here
