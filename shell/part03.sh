#!/bin/bash -e

#*************************************************************************************************************
#
# @script run_regist.sh
# @brief 位置合わせを行う
# @param[in] INPUTDIR SLCファイルが格納されたディレクトリ
# @param[in] MLIDIR 強度画像ディレクトリ
# @param[in] MASTER マスターファイル名（拡張子なし)
# @param[in] MODE_REG 位置合わせ方法（SLC:slcファイルによる位置合わせ MLI:強度画像を使用した位置合わせ）
# @param[in] MODE 処理ファイルリストを使用するかどうかの指定(ALL：使用しない ADD：リストにないファイルを処理する)
# @return
# @note
#
#*************************************************************************************************************

######################################################################################################
# arguments
######################################################################################################

workdir="$1"
ref_date="$2"

########################################################################
#
# @fn registSLC
# @brief SLCファイルを使用した位置合わせ
# @param[in] master 位置合わせのマスターのファイル名（拡張子なし）
# @param[in] slave  位置合わせのスレーブのファイル名（拡張子なし）
# @param[in] output 位置合わせ済みファイル出力ディレクトリ
# @return なし
# @note 
#
########################################################################
function registSLC()
{
    master="$1"
    slave="$2"
    output="$3"
    
    create_offset ${master}.slc.par ${slave}.slc.par ${output}/${master}to${slave}.off 1 - - 1 < ${workdir}/gamma_mod/prm.txt
    init_offset_orbit ${master}.slc.par ${slave}.slc.par ${output}/${master}to${slave}.off - - 1
    offset_pwr ${master}.slc ${slave}.slc ${master}.slc.par ${slave}.slc.par ${output}/${master}to${slave}.off ${output}/${master}to${slave}.offs ${output}/${master}to${slave}.snr 128 128 ${output}/${master}to${slave}.offset 1 - - -
    offset_fit ${output}/${master}to${slave}.offs ${output}/${master}to${slave}.snr ${output}/${master}to${slave}.off ${output}/${master}to${slave}.coff ${output}/${master}to${slave}.coffset 0.7 4
    SLC_interp ${slave}.slc ${master}.slc.par ${slave}.slc.par ${output}/${master}to${slave}.off ${slave}.rslc ${slave}.rslc.par

}

#######################################################################################################
# main
#######################################################################################################

# 関数を環境変数に設定（並列処理（paralellコマンド）用）
export -f registSLC

cd ${workdir}/input_rslc
slcNum=`ls -1 *.slc 2>/dev/null | wc -l`
master="${ref_date}"
if [ "${slcNum}" -ne 0 ];then
    if [ -e regist ];then rm -r regist; fi
    mkdir -p regist
    for file in `ls *.slc`
    do
        if [ ${file%.slc} != ${master} ];then registSLC ${master} ${file%.slc} regist; fi
    done
else
    echo "NO SLC FILE"
fi

cd ${workdir}/input_rslc

cp ${ref_date}.slc ${ref_date}.rslc
cp ${ref_date}.slc.par ${ref_date}.rslc.par

# write acquisition dates to text file "dates"
rm -f dates SLC_tab
for rslc_file in `ls -F *.rslc`
do
	date=`echo ${rslc_file} | awk -F"." '{print $1}' | sed -e "s/[^0-9]//g"`
	echo ${date} >> ${workdir}/input_rslc/tmp_dates
    rslcfile="${workdir}/input_rslc/${date}.rslc"
    rslcparfile="${workdir}/input_rslc/${date}.rslc.par"
    echo ${rslcfile} ${rslcparfile} >> ${workdir}/input_rslc/SLC_tab
done
cd ${workdir}/input_rslc
sort tmp_dates | uniq >> dates
rm tmp_dates