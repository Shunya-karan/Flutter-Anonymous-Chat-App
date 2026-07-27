
function avatarGenerator(){
    const totalAvatars=30;
    const randomAvatars=Math.floor(Math.random()*totalAvatars)+1

    return `avatr_${randomAvatars}`
}
module.exports={
    avatarGenerator
}
// console.log(avtarGenerator());