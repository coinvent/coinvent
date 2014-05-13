$(window).load(function () {
    "use strict";

/* ==============================================
PRELOADER
=============================================== */
    var preloaderDelay = 400;
    var preloaderFadeOutTime = 600;

    function hidePreloader() {
        var loadingAnimation = $('#loading-animation');
        var preloader = $('.preloader');
        loadingAnimation.fadeOut();
        preloader.delay(preloaderDelay).fadeOut(preloaderFadeOutTime);
    }
    hidePreloader();
});


(function ($) {

    var viewportHeight = $(window).height();

    /***** Nicescroll *****/
    $("html").niceScroll({
        zindex: 999,
        cursorborder: "",
        cursorborderradius: "6px",
        cursorwidth: "10px",
        cursorcolor: "#191919",
        cursoropacitymin: .5
    });

    function initNice() {
        if ($(window).innerWidth() <= 960) {
            $('html').niceScroll().remove();
        } else {
            $("html").niceScroll({
                zindex: 999,
                cursorborder: "",
                cursorborderradius: "6px",
                cursorwidth: "10px",
                cursorcolor: "#191919",
                cursoropacitymin: .5
            });
        }
    }
    $(window).load(initNice);
    $(window).resize(initNice);



    /***** Top Menu Fade Effect *****/
    if (Modernizr.mq("screen and (max-width:1024px)")) {
        jQuery("body").toggleClass("body");
    } else {
        var s = skrollr.init({
            mobileDeceleration: 1,
            edgeStrategy: 'set',
            forceHeight: false,
            smoothScrolling: true,
            smoothScrollingDuration: 300,
            easing: {
                WTF: Math.random,
                inverted: function (p) {
                    return 1 - p;
                }
            }
        });
    }

    /***** Testimonials *****/
    if ($('#testimonials').length > 0) {
        $("#testimonials").owlCarousel({
            navigation: false,
            slideSpeed: 600,
            autoPlay: 8000,
            paginationSpeed: 600,
            singleItem: true
        });
    }

    /***** Scroll to top button *****/
    $(window).scroll(function () {
        if ($(this).scrollTop() > 100) {
            $('.scrollup').fadeIn();
        } else {
            $('.scrollup').fadeOut();
        }
    });
    $('.scrollup').click(function () {
        $("html, body").animate({
            scrollTop: 0
        }, 1000);
        return false;
    });

    /***** Parallax Slider *****/
    var isMobile = false;
    if (Modernizr.mq('only all and (max-width: 1024px)')) {
        isMobile = true;
    }

    if (isMobile == false && ($('#parallax1').length || isMobile == false && $('#parallax2').length)) {
        $(window).stellar({
            responsive: true,
            scrollProperty: 'scroll',
            parallaxElements: false,
            horizontalScrolling: false,
            horizontalOffset: 0,
            verticalOffset: 0
        });
    }

    if ($.fn.revolution) {
        $('#home').revolution({
            delay: 15000,
            startwidth: 1170,
            startheight: 500,
            hideThumbs: 10,
            fullWidth: "off",
            fullScreen: "on",
            navigationType: "none",
            fullScreenOffsetContainer: "",
            touchenabled: "on",
            videoJsPath: "assets/video/"
        });
    }


    /* ==============================================
    CONTACT PAGE
    =============================================== */
    /* Contact Form Validation */
    if ($('#contact-form')[0]) {
        $('#contact-form').parsley().subscribe('parsley:form:validate', function (formInstance) {
            // We stop form submission for demo purpose
            formInstance.submitEvent.preventDefault();
            // we use here group validation with option force (validate even non required fields)
            if (formInstance.isValid('contact-field', true)) {
                $("#sendmessage").slideDown().delay(3000).slideUp();
            }
        });
    }

    /* Google Map */
    if ($('#map')[0]) {
        var contact_map;
        contact_map = new GMaps({
            el: '#map',
            lat: 25.771912,
            lng: -80.186868,
            zoomControl: false,
            zoomControlOpt: {
                style: 'SMALL',
                position: 'TOP_LEFT'
            },
            panControl: false,
            streetViewControl: false,
            mapTypeControl: false,
            overviewMapControl: false,
            styles: [{
                "featureType": "water",
                "elementType": "geometry",
                "stylers": [{
                    "color": "#193341"
                }]
            }, {
                "featureType": "landscape",
                "elementType": "geometry",
                "stylers": [{
                    "color": "#2c5a71"
                }]
            }, {
                "featureType": "road",
                "elementType": "geometry",
                "stylers": [{
                    "color": "#29768a"
                }, {
                    "lightness": -37
                }]
            }, {
                "featureType": "poi",
                "elementType": "geometry",
                "stylers": [{
                    "color": "#406d80"
                }]
            }, {
                "featureType": "transit",
                "elementType": "geometry",
                "stylers": [{
                    "color": "#406d80"
                }]
            }, {
                "elementType": "labels.text.stroke",
                "stylers": [{
                    "visibility": "on"
                }, {
                    "color": "#3e606f"
                }, {
                    "weight": 2
                }, {
                    "gamma": 0.84
                }]
            }, {
                "elementType": "labels.text.fill",
                "stylers": [{
                    "color": "#ffffff"
                }]
            }, {
                "featureType": "administrative",
                "elementType": "geometry",
                "stylers": [{
                    "weight": 0.6
                }, {
                    "color": "#1a3541"
                }]
            }, {
                "elementType": "labels.icon",
                "stylers": [{
                    "visibility": "off"
                }]
            }, {
                "featureType": "poi.park",
                "elementType": "geometry",
                "stylers": [{
                    "color": "#2c5a71"
                }]
            }]
        });

        setTimeout(function () {
            contact_map.addMarker({
                lat: 25.775912,
                lng: -80.186868,
                animation: google.maps.Animation.DROP,
                draggable: true,
                title: 'We are here'
            });
        }, 3000);
    }

    /* ==============================================
    PORTFOLIO PAGE
    =============================================== */
    if ($('#gallery').length > 0) {
        function mixitup() {
            $("#gallery").mixItUp({
                animation: {
                    duration: 400,
                    effects: "fade translateZ(-360px) stagger(34ms)",
                    easing: "ease",
                    queueLimit: 3,
                    animateChangeLayout: true,
                    animateResizeTargets: true
                }
            });
            bindHandlers();
        }

        function bindHandlers() {
            $("#ToggleLayout").on("click", function () {
                if ($("#ToggleLayout i").hasClass("fa-th")) {
                    $("#ToggleLayout i").removeClass().addClass("fa fa-list");
                    $("#gallery").mixItUp('changeLayout', {
                        containerClass: ''
                    });
                } else {
                    $("#ToggleLayout i").removeClass().addClass("fa fa-th");
                    $("#gallery").mixItUp('changeLayout', {
                        containerClass: 'list'
                    });
                };
            })
        }

        $('.magnific').magnificPopup({
            type: 'image',
            gallery: {
                enabled: true
            },
            removalDelay: 300,
            mainClass: 'mfp-fade'
        });
        mixitup();
    }


    /* ==============================================
    TOUR PAGE
    =============================================== */

    if ($('.tour-page').length > 0) {

        /***** Back to Top / Bottom buttons *****/
        $('#tour1_next').click(function () {
            $.scrollTo('#tour2', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour2_back').click(function () {
            $.scrollTo('#tour1', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour2_next').click(function () {
            $.scrollTo('#tour3', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour3_back').click(function () {
            $.scrollTo('#tour2', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour3_next').click(function () {
            $.scrollTo('#tour4', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour4_back').click(function () {
            $.scrollTo('#tour3', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour4_next').click(function () {
            $.scrollTo('#tour5', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour5_back').click(function () {
            $.scrollTo('#tour4', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour5_next').click(function () {
            $.scrollTo('#tour6', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });
        $('#tour_back_to_top').click(function () {
            $.scrollTo('#tour1', 1000, {
                offset: 0,
                'axis': 'y'
            });
        });

        /***** Revolution Slider *****/
        $('.banner').revolution({
            delay: 9000,
            startwidth: 1170,
            startheight: 550,
            fullWidth: "on",
            forceFullWidth: "on"
        });


        var callback = function () {
            var viewportHeight = $(window).height();
            var viewportWidth = $(window).width();
            var tour_title_height = $('.tour-title').height() + 100;
            var forcefullwidth_height = $('.forcefullwidth_wrapper_tp_banner').height();

            if (forcefullwidth_height < 400) {
                $(".tour-top").css('padding-top', '50px');
            } else {
                $(".tour-top").height(forcefullwidth_height - 15);
            }
        }

        $(document).ready(callback);
        $(window).resize(callback);

        setTimeout(function () {
            $('.tour-title h1').addClass('animated fadeIn')
        }, 1000);
        setTimeout(function () {
            $('.tour-title p').addClass('animated fadeIn')
        }, 1800);

        /***** Image Animation *****/


        $('.appear').appear();
        $('.appear').on('appear', function () {
            var svgData = {
                "svg-animated": {
                    "strokepath": [{
                        "path": "M 169.92 338.15 L 203.43 338.15",
                        "duration": 200
                    }, {
                        "path": "M 169.92 323.82 L 203.43 323.82",
                        "duration": 200
                    }, {
                        "path": "M 179.4 352.27 L 193.95 352.27",
                        "duration": 200
                    }, {
                        "path": "M 180.14,319.39 L 180.14,295.15      193.21,295.15 193.21,319.391    ",
                        "duration": 200
                    }, {
                        "path": "M179.06,316.62     c-14.84-3.45-25.89-16.75-25.89-32.64c0-18.51,15-33.51,33.51-33.51c18.51,0,33.51,15,33.51,33.51     c0,15.8-10.93,29.04-25.64,32.581",
                        "duration": 200
                    }, {
                        "path": "M 338.17,253.2 L 354.81,269.86      281.79,342.891 260.19,348.05 265.24,326.13 338.17,253.21    ",
                        "duration": 200
                    }, {
                        "path": "M 318.14 274.08 L 333.74 289.67",
                        "duration": 200
                    }, {
                        "path": "M 270.25 320.5 L 287.25 337.75",
                        "duration": 200
                    }, {
                        "path": "M 424.32,355.0 L 394.81,325.71      479.12,241.41 508.62,270.71 424.32,355.01    ",
                        "duration": 200
                    }, {
                        "path": "M 426.01 322.76 L 441.25 338",
                        "duration": 200
                    }, {
                        "path": "M 454.67 294.1 L 470 309.5",
                        "duration": 200
                    }, {
                        "path": "M 480.28 268.49 L 495.5 283.5",
                        "duration": 200
                    }, {
                        "path": "M 436.23 303.27 L 455.75 323.5",
                        "duration": 200
                    }, {
                        "path": "M 462.15 277.34 L 482 297.25",
                        "duration": 200
                    }, {
                        "path": "M 626.18,255.9 L 641.35,255.95      635.45,290.73 646.83,298.52 636.3,306.109 639.88,339.83 626.39,339.83    ",
                        "duration": 200
                    }, {
                        "path": "M 569.28,255.9 L 554.1,255.95      560,290.73 548.62,298.52 559.16,306.109 555.58,339.83 569.07,339.83    ",
                        "duration": 200
                    }, {
                        "path": "M597.1,274.71c4.41,0,7.98,3.57,7.98,7.98     s-3.58,7.98-7.98,7.98c-4.399,0-7.979-3.57-7.979-7.98C589.11,278.28,592.69,274.71,597.1,274.71",
                        "duration": 200
                    }, {
                        "path": "M597.1,309.01c4.41,0,7.98,3.57,7.98,7.98     s-3.58,7.98-7.98,7.98c-4.399,0-7.979-3.58-7.979-7.98C589.11,312.58,592.69,309.01,597.1,309.01",
                        "duration": 200
                    }, {
                        "path": "M 603.22 322.09 L 593.72 333.58",
                        "duration": 200
                    }],
                    "dimensions": {
                        "width": 800,
                        "height": 400
                    }
                }
            };
            $('#svg-animated').lazylinepainter({
                'svgData': svgData,
                'strokeWidth': 3,
                'strokeColor': '#00A2D9'
            });
            $('#svg-animated').lazylinepainter('paint');

        });



    }

})(jQuery);