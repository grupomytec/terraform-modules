#.env .secret 
export APP_ENVS="$TERRAFORM_TMP_DIR"

for i in `cat ./$branchdir/*.secrets`; do
   if [[ $i != \#* ]]; then
   echo $i | awk -F= '{print "{"; print "\t\"name\" = " "\""$1"\"""," ; print "\t\"valueFrom\" = " "\""$2"\"" ; print "}," }' >> $GITHUB_ENV
   fi
done