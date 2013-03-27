
(in-package #:slowly)


(defclass tile ()
  ((x :accessor xcoord 
      :initarg :x)
   (y :accessor ycoord 
      :initarg :y)
   (type :accessor type
         :initform :empty
         :initarg :type)))

(defgeneric tile-to-string (tile)
  (:documentation "Returns what the tile will be represented 
as on the screen")

(defgeneric tile-color (tile)
  (:documentation "Returns the tile's color"))

(defmacro deftile (type output color)
  `(defclass ,type (tile) () )
  `(defmethod tile-to-string ((tile ,type))
     (identity ,output))
  `(defmethod tile-color ((tile ,type))
     (identity ,color)))

(deftile wall-tile "#" :green)
(deftile floor-tile ".")
(deftile empty-tile " ")
