(in-package #:slowly)

(defclass map ()
  ((size-x :accessor size-x)
   (size-y :accessor size-y)
   (tiles :accessor tiles
          :initform (make-array 200 :adjustable t :fill-pointer 0))))

(defclass tile ()
  ((x :accessor xcoord 
      :initarg :x)
   (y :accessor ycoord 
      :initarg :y)
   (type :accessor type
         :initform :empty
         :initarg :type)))

(defmethod get-tile (x y (map map))
  (elt (tiles map) (+ x y)))

(defmethod push-tile (x y (map map) type)
  "Pushes it to the back and not to (x,y)"
  (vector-push-extend (make-instance 'tile :x x :y y :type type) (tiles map))
  (setf (size-x map) x)
  (setf (size-y map) y))

(defmethod display-map ((map map))
  (let ((x 0) (y -1))
    (map 'vector #'(lambda (tile) 
                     (progn 
                       (if (= 0 (xcoord tile))
                           (progn 
                             (incf y)
                             (setf x 0)))
                       (draw (tile-to-string tile) y x)
                       (incf x)))
         (tiles map))))

(defmethod tile-to-string ((tile tile))
  (switch ((type tile) :test eql)
    (:wall "#")
    (:floor ".")))

(defun load-map (filename)
  (let ((map (make-instance 'map))
        (x 0)
        (y 0))
    (with-open-file (stream filename)
      (do ((chr (read-char stream) (read-char stream nil 'the-end)))
          ((not (characterp chr)))
        (switch (chr :test char=)
          (#\Newline (progn
                       (setf x -1)
                       (incf y)))
          (#\# (push-tile x y map :wall))
          (#\. (push-tile x y map :floor)))
        (incf x))
    (identity map))))
