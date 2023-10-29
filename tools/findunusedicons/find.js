const regex = /'((.*)\.dmi)'/gm;

const ourbuilddir = '../../';
const glob 	= require("glob");
const fs 	= require('fs');

var   endray = [];
var	  dmiray = [];
var	  difray = [];

fs.writeFileSync("unused_dmi.txt", '');
fs.writeFileSync("found_dmi.txt", '');
fs.writeFileSync("found_used_dmi.txt", '');

console.log(" > Finding DM");

glob(ourbuilddir + "**/*.dm", function (er, files) {
	console.log(" > Sorting DM");
	files.forEach((file) => {
		var str = fs.readFileSync(file, 'utf8');
		let m;
		while ((m = regex.exec(str)) !== null) {
			if (m.index === regex.lastIndex) {
				regex.lastIndex++;
			}
			m.forEach((match, groupIndex) => {
				if(groupIndex == 1) {
					endray.push(match);
				};
			});
		};
	});
	console.log(" > Filtering DM");
	uniqueArray = endray.filter(function(elem, pos) {
		return endray.indexOf(elem) == pos;
	})

	console.log(" > Writing DM");
	uniqueArray.forEach((l) => {
		fs.appendFileSync("found_used_dmi.txt", `${l}\n`);
	});
	
	endray = uniqueArray;
});

console.log(" > Finding DMI");

glob(ourbuilddir + "**/*.dmi", function (er, files) {
	console.log(" > Filtering DMI");

	files.forEach((l) => {
		dmiray.push(l.replace('../../', ''));
	});

	dmiray = dmiray.filter(function(elem, pos) {
		return dmiray.indexOf(elem) == pos;
	});
	
	console.log(" > Writing DMI");
	dmiray.forEach((l) => {
		fs.appendFileSync("found_dmi.txt", `${l}\n`);
	});
	
	console.log(" > Comparing...");
	difray = endray.filter(val => !dmiray.includes(val));
	
	console.log(" > Writing Unused");
	difray.forEach((l) => {
		fs.appendFileSync("unused_dmi.txt", `${l}\n`);
	});
});