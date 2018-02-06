#!/usr/bin/env csh
#
if ($# != 3) then 
 echo 'Usage:    ' $0 ' run1_data.star particles_movie.star  particles_movie_subset.star'
 echo 'Where run1_data.star is a selection of an originally larger data set of the averaged particles.'
 echo 'The input particles_movie.star contains the movie frames of the entire larger data set.'
 echo 'The output particles_movie_subset.star will contain the movie frames only for those particles in run1_data.star.'
 echo 'Using particles_movie_subset.star in a continuation of run1 will speed up the expansion of the movie frames.'
else

 zip saveddata.zip $1 $2 $3
 set star_selected_particles=$1
 set star_all_movies_frame=$2
 set star_selected_movie_frames=$3
 awk '{if (NF > 3) exit; print }' < ${star_all_movies_frame} > ${star_selected_movie_frames}
 
 relion_star_printtable ${star_selected_particles} data_ rlnMicrographName | sort | uniq | sed 's|.mrc||' > mics.dat
 relion_star_printtable ${star_selected_particles} data_ rlnImageName > parts.dat
 foreach m (`cat mics.dat`)
  grep $m ${star_all_movies_frame} > mics_part.dat
  grep $m parts.dat > parts_mic.dat
  foreach p (`cat parts_mic.dat`)
   grep ${p} mics_part.dat  >> ${star_selected_movie_frames}
  end
  echo -n "."
 end
 echo " "
 echo "done!"
endif

