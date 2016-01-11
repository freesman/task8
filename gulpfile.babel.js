// generated on 2015-12-01 using generator-gulp-webapp 1.0.3
import gulp from 'gulp';
import gulpLoadPlugins from 'gulp-load-plugins';
import browserSync from 'browser-sync';
import del from 'del';

const $ = gulpLoadPlugins();
const reload = browserSync.reload;

gulp.task('styles', () => {
  return gulp.src('app/styles/*.scss')
    .pipe($.plumber())
    .pipe($.sourcemaps.init())
    .pipe($.sass.sync({
      outputStyle: 'expanded',
      precision: 10,
      includePaths: ['.']
    }).on('error', $.sass.logError))
    .pipe($.autoprefixer({browsers: ['last 1 version']}))
    .pipe($.sourcemaps.write())
    .pipe(gulp.dest('.tmp/styles'))
    .pipe(reload({stream: true}));
});

function lint(files, options) {
  return () => {
    return gulp.src(files)
      .pipe(reload({stream: true, once: true}))
      .pipe($.eslint(options))
      .pipe($.eslint.format())
      .pipe($.if(!browserSync.active, $.eslint.failAfterError()));
  };
}
const testLintOptions = {
  env: {
    mocha: true
  }
};

gulp.task('lint', lint('app/scripts/**/*.js'));
gulp.task('lint:test', lint('test/spec/**/*.js', testLintOptions));

gulp.task('html', ['views', 'templates', 'minify:templates', 'styles', 'scripts'], () => {
  
  const assets = $.useref.assets({searchPath: ['.tmp', 'app', '.']});

  return gulp.src(['app/*.html', '.tmp/*.html'])
    .pipe(assets)
    .pipe($.if('*.js', $.uglify()))
    .pipe($.if('*.css', $.minifyCss({compatibility: '*'})))
    .pipe(assets.restore())
    //.pipe($.useref())
    .pipe($.htmlReplace({
      modernizr: 'scripts/bower/modernizr.js',
      require:{
        src: [['scripts/main', 'scripts/bower/require.js']],
        tpl: '<script data-main="%s" src="%s"></script>',
      }
    }))
    .pipe($.if('*.html', $.minifyHtml({conditionals: true, loose: true})))
    .pipe(gulp.dest('dist'));
  
});

gulp.task('images', () => {
  return gulp.src('app/images/**/*')
    .pipe($.if($.if.isFile, $.cache($.imagemin({
      progressive: true,
      interlaced: true,
      // don't remove IDs from SVGs, they are often used
      // as hooks for embedding and styling
      svgoPlugins: [{cleanupIDs: false}]
    }))
    .on('error', function (err) {
      console.log(err);
      this.end();
    })))
    .pipe(gulp.dest('dist/images'));
});

gulp.task('fonts', () => {
  return gulp.src(require('main-bower-files')({
    filter: '**/*.{eot,svg,ttf,woff,woff2}'
  }).concat('app/fonts/**/*'))
    .pipe(gulp.dest('.tmp/fonts'))
    .pipe(gulp.dest('dist/fonts'));
});

gulp.task('extras', () => {
  return gulp.src([
    'app/*.*',
    '!app/*.html',
    '!app/*.jade'
  ], {
    dot: true
  }).pipe(gulp.dest('dist'));
});

gulp.task('clean', del.bind(null, ['.tmp', 'dist']));

gulp.task('serve', ['views', 'styles', 'scripts', 'fonts'], () => {
  browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['.tmp', 'app'],
      routes: {
        '/bower_components': 'bower_components'
      }
    }
  });

  gulp.watch([
    'app/*.html',
    '.tmp/*.html',
    'app/scripts/**/*.js',
    '.tmp/scripts/**/*.js',
    'app/images/**/*',
    '.tmp/fonts/**/*'
  ]).on('change', reload);

  gulp.watch('app/**/*.jade', ['views']);
  gulp.watch('app/styles/**/*.scss', ['styles']);
  gulp.watch('app/scripts/**/*.coffee', ['scripts', reload]);
  gulp.watch('app/fonts/**/*', ['fonts']);
  gulp.watch('bower.json', ['fonts']);
});

gulp.task('serve:dist', () => {
  browserSync({
    notify: false,
    port: 9000,
    server: {
      baseDir: ['dist']
    }
  });
});

gulp.task('serve:test', () => {
  browserSync({
    notify: false,
    port: 9000,
    ui: false,
    server: {
      baseDir: 'test',
      routes: {
        '/bower_components': 'bower_components'
      }
    }
  });

  gulp.watch('test/spec/**/*.js').on('change', reload);
  gulp.watch('test/spec/**/*.js', ['lint:test']);
});

// inject bower components

// default building all components
gulp.task('default', ['clean'], () => {
  gulp.start('build-modules');
});

gulp.task('build-modules', ['html', 'bower', 'bower:path', 'images', 'fonts', 'extras'], () => {
  gulp.start('build-size');
});

gulp.task('build-size', ['modules'], () => {
  return gulp.src('dist/**/*').pipe($.size({title: 'build', gzip: true}));
});
// --- end def building

gulp.task('views', () => {
  return gulp.src('app/*.jade')
    .pipe($.jade({pretty: true}))
    .pipe(gulp.dest('.tmp'))
    .pipe(reload({stream: true}));
});

gulp.task('scripts', () => {
  return gulp.src('app/scripts/**/*.coffee')
    .pipe($.coffee())
    .pipe(gulp.dest('.tmp/scripts'));
});

gulp.task('deploy', ['build-size'], () => {
  return gulp.src('./dist/**/*')
    .pipe($.ghPages());
});

gulp.task('dep', () => {
  return gulp.src('./dist/**/*')
    .pipe($.ghPages());
});

gulp.task('modules', $.shell.task(['r.js.cmd -o build.js']));

gulp.task('bower', () => {
  return gulp.src(['bower_components/modernizr/modernizr.js', 'bower_components/requirejs/require.js'])
    .pipe(gulp.dest('dist/scripts/bower'));
});

gulp.task('bower:path', () => {
  return gulp.src(['dist/index.html'])
    .pipe($.htmlReplace({
      modernizr: 'scripts/bower/modernizr.js',
      require:{
        src: [['scripts/main', 'scripts/bower/require.js']],
        tpl: '<script data-main="%s" src="%s"></script>',
      }
    }))
    .pipe(gulp.dest('dist/html'));
});

gulp.task('templates', () => {
  return gulp.src('app/scripts/templates/*.jade')
    .pipe($.jade({pretty: true}))
    .pipe(gulp.dest('.tmp/scripts/templates'))
    .pipe(reload({stream: true}));
});

gulp.task('minify:templates', () => {
  return gulp.src('.tmp/scripts/templates/*.html')
    .pipe($.minifyHtml({conditionals: true, loose: true}))
    .pipe(gulp.dest('.tmp/scripts/templates'))
    .pipe(reload({stream: true}));
});